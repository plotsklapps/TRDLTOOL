import 'package:material_ui/material_ui.dart';
import 'package:signals/signals_flutter.dart';

final Signal<ThemeMode> sThemeMode = Signal<ThemeMode>(
  ThemeMode.light,
  options: const SignalOptions<ThemeMode>(name: 'sThemeMode'),
);
