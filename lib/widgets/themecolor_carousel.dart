import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/signals/themecolor_signal.dart';
import 'package:trdltool/theme/flex_theme.dart';

class ThemeColorCarousel extends SignalWidget {
  const ThemeColorCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    const List<FlexScheme> schemes = FlexScheme.values;
    final FlexScheme selectedScheme = sThemeColor.value;

    return SizedBox(
      height: 140,
      child: CarouselView(
        itemExtent: 100,
        shrinkExtent: 100,
        onTap: (int index) {
          // Update the sThemeColor Signal.
          sThemeColor.value = schemes[index];
        },
        children: <Widget>[
          for (final FlexScheme scheme in schemes)
            Container(
              decoration: BoxDecoration(
                color: cThemeData.value.colorScheme.surfaceDim,
                border: Border.all(
                  color: scheme == selectedScheme
                      ? cThemeData.value.colorScheme.primary
                      : Colors.transparent,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
                    child: SizedBox(
                      height: 88, // 2 rows of 40 + spacing
                      child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        children: <Widget>[
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: FlexColorScheme.light(
                                scheme: scheme,
                              ).primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: FlexColorScheme.light(
                                scheme: scheme,
                              ).secondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: FlexColorScheme.light(
                                scheme: scheme,
                              ).tertiary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: FlexColorScheme.light(
                                scheme: scheme,
                              ).primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    scheme.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: scheme == selectedScheme
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: cThemeData.value.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
