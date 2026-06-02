import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:signals/signals_flutter.dart';

// Signal to hold the AppThemeColor.
final Signal<FlexScheme> sThemeColor = Signal<FlexScheme>(
  FlexScheme.redWine,
  options: const SignalOptions<FlexScheme>(name: 'sThemeColor'),
);
