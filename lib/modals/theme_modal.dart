import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/logic/scroll_logic.dart';
import 'package:trdltool/signals/thememode_signal.dart';
import 'package:trdltool/widgets/themecolor_carousel.dart';
import 'package:trdltool/widgets/themefont_carousel.dart';

class ThemeModal extends SignalWidget {
  const ThemeModal({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollConfiguration(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                'App Instellingen',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              const SizedBox(height: 16),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Pop the bottomsheet.
                        Navigator.pop(context);
                      },
                      child: const Text('Annuleren'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        // Pop the bottomsheet.
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Bewaren'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
