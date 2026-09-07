import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class GriStatusDisplay extends StatelessWidget {
  const GriStatusDisplay({required this.statusText, super.key});

  final String statusText;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isActiveCall = statusText.toUpperCase() != 'GEEN ACTIEVE OPROEP';

    Color backgroundColor;
    Color borderColor;
    Color textColor;
    IconData iconData;

    if (isActiveCall) {
      backgroundColor = colorScheme.secondaryContainer;
      borderColor = colorScheme.secondary;
      textColor = colorScheme.onSecondaryContainer;
      iconData = LucideIcons.phoneForwarded;
    } else {
      backgroundColor = colorScheme.surfaceContainerHigh;
      borderColor = colorScheme.outlineVariant;
      textColor = colorScheme.onSurfaceVariant;
      iconData = LucideIcons.phoneOff;
    }

    return SizedBox(
      width: double.infinity,
      height: 76,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor, width: isActiveCall ? 2 : 1.5),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isActiveCall
              ? <BoxShadow>[
                  BoxShadow(
                    color: borderColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (isActiveCall)
                Animate(
                  effects: const <Effect<dynamic>>[
                    ScaleEffect(
                      duration: Duration(milliseconds: 800),
                      curve: Curves.easeInOut,
                    ),
                    FadeEffect(duration: Duration(milliseconds: 800)),
                  ],
                  onPlay: (AnimationController controller) =>
                      controller.repeat(reverse: true),
                  child: Icon(iconData, color: textColor, size: 24),
                )
              else
                Icon(iconData, color: textColor, size: 22),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  isActiveCall
                      ? 'ACTIEVE OPROEP: ${statusText.toUpperCase()}'
                      : statusText.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: isActiveCall ? 16 : 14,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
