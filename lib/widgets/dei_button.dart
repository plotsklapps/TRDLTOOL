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

  String _getSummarySubtitle(DeiModel dei) {
    switch (dei.deiType) {
      case '1':
        return dei.seinnummer != null && dei.seinnummer!.isNotEmpty
            ? 'Sein ${dei.seinnummer}'
            : 'Passeren stoptonend sein';
      case '2':
        final List<String> modes = <String>[];
        if (dei.doorrijdenSR == true) modes.add('SR');
        if (dei.doorrijdenSH == true) modes.add('SH');
        return modes.isNotEmpty
            ? 'Doorrijden in ${modes.join('/')}'
            : 'Doorrijden na TRIP';
      case '3':
        return 'Stil blijven staan';
      case '4':
        return dei.ingetrokkenIdNummer != null &&
                dei.ingetrokkenIdNummer!.isNotEmpty
            ? 'Ingetrokken ID: ${dei.ingetrokkenIdNummer}'
            : 'Intrekken DEI';
      case '5':
      case '6':
        final String van = (dei.emplacementVan ?? '').toUpperCase();
        final String tot = (dei.emplacementTot ?? '').toUpperCase();
        final String km =
            dei.kilometerVan != null && dei.kilometerVan!.isNotEmpty
            ? ' (km ${dei.kilometerVan}-${dei.kilometerTot ?? ''})'
            : '';
        return '$van - $tot$km';
      case '7':
        final List<String> modes = <String>[];
        if (dei.vertrekkenSR == true) modes.add('SR');
        if (dei.vertrekkenSH == true) modes.add('SH');
        return modes.isNotEmpty
            ? 'Vertrekken in ${modes.join('/')}'
            : 'Toestemming om te vertrekken';
      case '8':
        final String van = (dei.emplacementVan ?? '').toUpperCase();
        final String tot = (dei.emplacementTot ?? '').toUpperCase();
        final int count = dei.overwegen?.length ?? 0;
        return '$van - $tot ($count overwegen)';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isActive = dei.status == 'isCalling' || dei.status == 'isActive';
    final bool isCompleted = dei.status == 'completed';

    final String titleText = 'DEI ${dei.deiType} - Trein ${dei.treinnummer}';
    final String summaryText = _getSummarySubtitle(dei);

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
                        if (summaryText.isNotEmpty)
                          Text(
                            summaryText,
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
                      avatar: isCompleted
                          ? Icon(
                              LucideIcons.checkCheck,
                              size: 14,
                              color: colorScheme.onPrimaryContainer,
                            )
                          : null,
                      label: Text(
                        isCompleted
                            ? 'ID: ${dei.identificatienummer} • BEVESTIGD'
                            : 'ID: ${dei.identificatienummer}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isCompleted
                              ? colorScheme.onPrimaryContainer
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                      backgroundColor: isCompleted
                          ? colorScheme.primaryContainer
                          : colorScheme.surfaceContainerHighest,
                      side: BorderSide(
                        color: isCompleted
                            ? colorScheme.primary
                            : colorScheme.outline,
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
