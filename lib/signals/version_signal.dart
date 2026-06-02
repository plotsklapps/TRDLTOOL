import 'package:package_info_plus/package_info_plus.dart';
import 'package:signals/signals_flutter.dart';

// String Signal to hold app version, defaults to null until loaded.
final Signal<String?> sVersionSignal = Signal<String?>(
  null,
  options: const SignalOptions<String?>(name: 'sVersionSignal'),
);

// Computed String Signal to provide a non-null version String.
final Computed<String> sVersion = Computed<String>(
  () {
    return sVersionSignal.value ?? 'Loading...';
  },
  options: const ComputedOptions<String>(name: 'sVersion'),
);

// Method called in main.dart, user always sees the latest version fetched
// from package_info_plus (pubspec.yaml).
Future<void> loadAppVersion() async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  sVersionSignal.value =
      info.version +
      (info.buildNumber.isNotEmpty ? '+${info.buildNumber}' : '');
}
