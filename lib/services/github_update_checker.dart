import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const String _githubOwner = 'Bhupesh0009';
const String _githubRepo = 'Stoma_Saathi';
const String _currentAppVersion = String.fromEnvironment(
  'APP_VERSION',
  defaultValue: '1.0.0',
);

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
      final release = await GithubReleaseService.fetchLatestRelease();
      if (release == null || !release.isNewerThan(_currentAppVersion)) {
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
      await _showUpdateDialog(release, prefs);
    } catch (_) {
      // Update checks should never interrupt normal app usage.
    }
  }

  Future<void> _showUpdateDialog(
    GithubRelease release,
    SharedPreferences prefs,
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
            'You are using $_currentAppVersion.',
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
    final latestParts = _versionParts(versionTag);
    final currentParts = _versionParts(currentVersion);
    final maxLength = latestParts.length > currentParts.length
        ? latestParts.length
        : currentParts.length;

    for (var i = 0; i < maxLength; i++) {
      final latest = i < latestParts.length ? latestParts[i] : 0;
      final current = i < currentParts.length ? currentParts[i] : 0;
      if (latest > current) {
        return true;
      }
      if (latest < current) {
        return false;
      }
    }
    return false;
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

  static List<int> _versionParts(String version) {
    final normalized = version
        .trim()
        .replaceFirst(RegExp(r'^[vV]'), '')
        .split(RegExp(r'[-+]'))
        .first;

    return normalized
        .split('.')
        .map((part) => int.tryParse(part) ?? 0)
        .toList(growable: false);
  }
}

class GithubReleaseAsset {
  const GithubReleaseAsset({required this.name, required this.downloadUrl});

  final String name;
  final String downloadUrl;
}
