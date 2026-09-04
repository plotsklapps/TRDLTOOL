import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trdltool/models/dei_model.dart';

class DeiButton extends StatelessWidget {
  const DeiButton({
    required this.dei,
    required this.userRole,
    required this.onTap,
    super.key,
  });

  final DeiModel dei;
  final String userRole;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isActive = dei.status == 'isCalling' || dei.status == 'isActive';
    final bool isCompleted = dei.status == 'completed';

    final String titleText = 'DEI ${dei.deiType} - Trein ${dei.treinnummer}';
    final String kmText = dei.kilometerVan.isNotEmpty
        ? ' (km ${dei.kilometerVan}-${dei.kilometerTot})'
        : '';
    final String routeText =
        '${dei.emplacementVan.toUpperCase()} - '
        '${dei.emplacementTot.toUpperCase()}$kmText';

    Color backgroundColor;
    Color textColor;

    if (isActive) {
      backgroundColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimaryContainer;
    } else if (isCompleted) {
      backgroundColor = colorScheme.secondaryContainer;
      textColor = colorScheme.onSecondaryContainer;
    } else {
      backgroundColor = colorScheme.surfaceContainerHigh;
      textColor = colorScheme.onSurface;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: <Widget>[
            if (isActive)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.primaryContainer,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: <Widget>[
                  Icon(
                    LucideIcons.fileText,
                    color: colorScheme.primary,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          titleText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        if (routeText.isNotEmpty)
                          Text(
                            routeText,
                            style: TextStyle(
                              fontSize: 12,
                              color: textColor.withValues(alpha: 0.8),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (dei.identificatienummer != null)
                    Chip(
                      label: Text(
                        'ID: ${dei.identificatienummer}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
