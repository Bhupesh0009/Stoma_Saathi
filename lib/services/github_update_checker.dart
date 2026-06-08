import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const String _githubOwner = 'Bhupesh0009';
const String _githubRepo = 'Stoma_Saathi';

class GithubUpdateChecker extends StatefulWidget {
  const GithubUpdateChecker({super.key, required this.child});

  final Widget child;

  @override
  State<GithubUpdateChecker> createState() => _GithubUpdateCheckerState();
}

class _GithubUpdateCheckerState extends State<GithubUpdateChecker> {
  bool _checkedThisSession = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_checkedThisSession) {
      return;
    }
    _checkedThisSession = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
  }

  Future<void> _checkForUpdate() async {
    if (!mounted) {
      return;
    }

    try {
      final currentVersion = await _currentInstalledVersion();
      final release = await GithubReleaseService.fetchLatestRelease();
      if (release == null || !release.isNewerThan(currentVersion)) {
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final skippedTag = prefs.getString('skipped_update_tag');
      if (skippedTag == release.versionTag) {
        return;
      }

      if (!mounted) {
        return;
      }
      await _showUpdateDialog(release, prefs, currentVersion);
    } catch (_) {
      // Update checks should never interrupt normal app usage.
    }
  }

  Future<String> _currentInstalledVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (packageInfo.buildNumber.isEmpty) {
      return packageInfo.version;
    }
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }

  Future<void> _showUpdateDialog(
    GithubRelease release,
    SharedPreferences prefs,
    String currentVersion,
  ) async {
    final downloadUrl = release.preferredDownloadUrl;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Update available'),
          content: Text(
            'Stoma Saathi ${release.versionTag} is available. '
            'You are using $currentVersion.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await prefs.setString('skipped_update_tag', release.versionTag);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Skip'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Later'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.system_update_alt_rounded),
              label: const Text('Update'),
              onPressed: () async {
                final navigator = Navigator.of(context);
                await launchUrl(
                  Uri.parse(downloadUrl),
                  mode: LaunchMode.externalApplication,
                );
                navigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class GithubReleaseService {
  static const _latestReleaseUrl =
      'https://api.github.com/repos/$_githubOwner/$_githubRepo/releases/latest';

  static Future<GithubRelease?> fetchLatestRelease() async {
    final response = await NetworkAssetBundle(
      Uri.parse(_latestReleaseUrl),
    ).loadString('');
    final data = jsonDecode(response);
    if (data is! Map<String, Object?>) {
      return null;
    }

    final tagName = data['tag_name'];
    final htmlUrl = data['html_url'];
    final assetsJson = data['assets'];
    if (tagName is! String || htmlUrl is! String) {
      return null;
    }

    final assets = <GithubReleaseAsset>[];
    if (assetsJson is List) {
      for (final assetJson in assetsJson) {
        if (assetJson is! Map<String, Object?>) {
          continue;
        }
        final name = assetJson['name'];
        final browserDownloadUrl = assetJson['browser_download_url'];
        if (name is String && browserDownloadUrl is String) {
          assets.add(
            GithubReleaseAsset(name: name, downloadUrl: browserDownloadUrl),
          );
        }
      }
    }

    return GithubRelease(
      versionTag: tagName,
      releaseUrl: htmlUrl,
      assets: assets,
    );
  }
}

class GithubRelease {
  const GithubRelease({
    required this.versionTag,
    required this.releaseUrl,
    required this.assets,
  });

  final String versionTag;
  final String releaseUrl;
  final List<GithubReleaseAsset> assets;

  String get preferredDownloadUrl {
    final preferredAsset = _assetForCurrentPlatform();
    return preferredAsset?.downloadUrl ?? releaseUrl;
  }

  bool isNewerThan(String currentVersion) {
    final latestVersion = _ReleaseVersion.parse(versionTag);
    final current = _ReleaseVersion.parse(currentVersion);
    final maxLength = latestVersion.parts.length > current.parts.length
        ? latestVersion.parts.length
        : current.parts.length;

    for (var i = 0; i < maxLength; i++) {
      final latestPart = i < latestVersion.parts.length
          ? latestVersion.parts[i]
          : 0;
      final currentPart = i < current.parts.length ? current.parts[i] : 0;
      if (latestPart > currentPart) {
        return true;
      }
      if (latestPart < currentPart) {
        return false;
      }
    }
    return latestVersion.buildNumber > current.buildNumber;
  }

  GithubReleaseAsset? _assetForCurrentPlatform() {
    final preferredExtensions = switch (defaultTargetPlatform) {
      TargetPlatform.android => ['.apk'],
      TargetPlatform.windows => ['.msix', '.exe', '.zip'],
      TargetPlatform.macOS => ['.dmg', '.pkg', '.zip'],
      TargetPlatform.linux => ['.appimage', '.deb', '.rpm', '.tar.gz', '.zip'],
      TargetPlatform.iOS => <String>[],
      TargetPlatform.fuchsia => <String>[],
    };

    for (final extension in preferredExtensions) {
      for (final asset in assets) {
        if (asset.name.toLowerCase().endsWith(extension)) {
          return asset;
        }
      }
    }
    return null;
  }
}

class GithubReleaseAsset {
  const GithubReleaseAsset({required this.name, required this.downloadUrl});

  final String name;
  final String downloadUrl;
}

class _ReleaseVersion {
  const _ReleaseVersion({required this.parts, required this.buildNumber});

  final List<int> parts;
  final int buildNumber;

  static _ReleaseVersion parse(String version) {
    final normalized = version.trim().replaceFirst(RegExp(r'^[vV]'), '');
    final buildSplit = normalized.split('+');
    final parts = buildSplit.first
        .split('-')
        .first
        .split('.')
        .map((part) => int.tryParse(part) ?? 0)
        .toList(growable: false);
    final buildNumber = buildSplit.length > 1
        ? int.tryParse(buildSplit[1].split('-').first) ?? 0
        : 0;

    return _ReleaseVersion(parts: parts, buildNumber: buildNumber);
  }
}
