import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform/platform.dart';

import '../../core/injector/injector.dart';

/// Utility class to provide platform and application information.
class PlatformUtils {
  PlatformUtils({
    PackageInfo? packageInfo,
    LocalPlatform? localPlatform,
  }) : _packageInfo = packageInfo ?? CoreInjector.instance.get<PackageInfo>(),
       _localPlatform =
           localPlatform ?? CoreInjector.instance.get<LocalPlatform>();

  final LocalPlatform _localPlatform;
  final PackageInfo _packageInfo;

  String get operatingSystem => _localPlatform.operatingSystem;

  String get operatingSystemVersion => _localPlatform.operatingSystemVersion;

  String get appVersion => _packageInfo.version;

  String get buildNumber => _packageInfo.buildNumber;

  String get appName => _packageInfo.appName;

  String get packageName => _packageInfo.packageName;

  String get fullAppVersion => '$appVersion ($buildNumber)';
}
