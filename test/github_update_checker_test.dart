import 'package:flutter_test/flutter_test.dart';
import 'package:stoma_saathi/services/github_update_checker.dart';

GithubRelease _release(String versionTag) {
  return GithubRelease(
    versionTag: versionTag,
    releaseUrl: '',
    assets: const [],
  );
}

void main() {
  group('GithubRelease.isNewerThan', () {
    test('does not show an update for the same installed version', () {
      expect(_release('v1.0.2').isNewerThan('1.0.2+3'), isFalse);
      expect(_release('v1.0.2+3').isNewerThan('1.0.2+3'), isFalse);
    });

    test('shows an update for newer version or build number', () {
      expect(_release('v1.0.3').isNewerThan('1.0.2+3'), isTrue);
      expect(_release('v1.0.2+4').isNewerThan('1.0.2+3'), isTrue);
    });
  });
}
