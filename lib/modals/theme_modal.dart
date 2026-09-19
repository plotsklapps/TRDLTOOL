import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/modals/base_modal.dart';
import 'package:trdltool/signals/thememode_signal.dart';
import 'package:trdltool/widgets/themecolor_carousel.dart';
import 'package:trdltool/widgets/themefont_carousel.dart';

class ThemeModal extends SignalWidget {
  const ThemeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: 'Thema & Uiterlijk',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<ThemeMode>(
              segments: const <ButtonSegment<ThemeMode>>[
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.light,
                  icon: Icon(LucideIcons.spotlight),
                  label: Text('Licht'),
                ),
                ButtonSegment<ThemeMode>(
                  value: ThemeMode.dark,
                  icon: Icon(LucideIcons.moonStar),
                  label: Text('Donker'),
                ),
              ],
              selected: <ThemeMode>{sThemeMode.value},
              onSelectionChanged: (Set<ThemeMode> newSelection) {
                sThemeMode.value = newSelection.first;
              },
            ),
          ),
          const SizedBox(height: 24),
          const ThemeColorCarousel(),
          const SizedBox(height: 24),
          const ThemeFontCarousel(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Material(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              elevation: 2,
              child: InkWell(
                onTap: () {
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Text(
                    'BEWAREN',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
