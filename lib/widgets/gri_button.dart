import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trdltool/services/database_service.dart';

class GriButton extends StatefulWidget {
  const GriButton({
    required this.buttonName,
    required this.userRole,
    required this.buttonStates,
    required this.buttonInitiators,
    required this.buttonDetails,
    required this.databaseService,
    required this.buttonColor,
    required this.labelColor,
    this.progressIndicatorColor,
    this.onPressed,
    this.onCallEnded,
    this.overrideLabel,
    this.icon,
    super.key,
  });

  final String buttonName;
  final String userRole;
  final Map<String, String> buttonStates;
  final Map<String, String> buttonInitiators;
  final Map<String, String?> buttonDetails;
  final DatabaseService databaseService;
  final Color buttonColor;
  final Color labelColor;
  final Color? progressIndicatorColor;
  final VoidCallback? onPressed;
  final VoidCallback? onCallEnded;
  final String? overrideLabel;
  final IconData? icon;

  @override
  State<GriButton> createState() {
    return _GriButtonState();
  }
}

class _GriButtonState extends State<GriButton> {
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void didUpdateWidget(GriButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final String newState = widget.buttonStates[widget.buttonName] ?? 'rest';
    final String oldState = oldWidget.buttonStates[widget.buttonName] ?? 'rest';

    if (newState == 'isActive' && oldState != 'isActive') {
      _startTimer();
    } else if (newState != 'isActive') {
      _stopTimer();
      if (oldState == 'isActive' && widget.onCallEnded != null) {
        widget.onCallEnded!();
      }
    }
  }

  void _startTimer() {
    _secondsElapsed = 0;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (mounted) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _secondsElapsed = 0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    final DateTime time = DateTime(0, 0, 0, 0, minutes, secs);
    return DateFormat('mm:ss').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final String state = widget.buttonStates[widget.buttonName] ?? 'rest';
    final String initiator = widget.buttonInitiators[widget.buttonName] ?? '';
    final String? details = widget.buttonDetails[widget.buttonName];

    String labelText = widget.overrideLabel ?? widget.buttonName;
    if (details != null && details.isNotEmpty) {
      labelText = '$labelText $details';
    }

    VoidCallback? resolvedOnPressed;

    switch (state) {
      case 'isCalling':
        if (initiator == widget.userRole) {
          resolvedOnPressed = () async {
            await widget.databaseService.saveButtonPress(
              widget.buttonName,
              widget.userRole,
              'rest',
            );
          };
        } else {
          resolvedOnPressed = () async {
            await widget.databaseService.saveButtonPress(
              widget.buttonName,
              widget.userRole,
              'isActive',
              details: widget.buttonDetails[widget.buttonName],
            );
          };
        }
      case 'isActive':
        resolvedOnPressed = () async {
          await widget.databaseService.saveButtonPress(
            widget.buttonName,
            widget.userRole,
            'rest',
          );
        };
      case 'rest':
      default:
        resolvedOnPressed =
            widget.onPressed ??
            () async {
              await widget.databaseService.saveButtonPress(
                widget.buttonName,
                widget.userRole,
                'isCalling',
              );
            };
    }

    switch (state) {
      case 'isCalling':
        return _buildCallingButton(
          context,
          colorScheme,
          labelText,
          initiator == widget.userRole,
          resolvedOnPressed,
        );
      case 'isActive':
        return _buildActiveButton(
          context,
          colorScheme,
          labelText,
          resolvedOnPressed,
        );
      case 'rest':
      default:
        return _buildRestButton(context, labelText, resolvedOnPressed);
    }
  }

  Widget _buildRestButton(
    BuildContext context,
    String labelText,
    VoidCallback? onPressed,
  ) {
    Widget content;
    if (widget.icon != null) {
      if (labelText.isNotEmpty) {
        content = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(widget.icon, color: widget.labelColor, size: 22),
            const SizedBox(width: 8),
            Text(
              labelText,
              style: TextStyle(
                color: widget.labelColor,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      } else {
        content = Icon(widget.icon, color: widget.labelColor, size: 26);
      }
    } else {
      content = Text(
        labelText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: widget.labelColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Material(
        color: widget.buttonColor,
        borderRadius: BorderRadius.circular(16),
        elevation: 1,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: content),
          ),
        ),
      ),
    );
  }

  Widget _buildCallingButton(
    BuildContext context,
    ColorScheme colorScheme,
    String labelText,
    bool isInitiator,
    VoidCallback? onPressed,
  ) {
    final IconData iconData = isInitiator
        ? LucideIcons.phoneOutgoing
        : LucideIcons.phoneIncoming;
    final String statusSubtext = isInitiator ? 'Bellen...' : 'Inkomende oproep';

    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Animate(
        effects: const <Effect<dynamic>>[
          ScaleEffect(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            begin: Offset(0.98, 0.98),
            end: Offset(1.02, 1.02),
          ),
        ],
        onPlay: (AnimationController controller) =>
            controller.repeat(reverse: true),
        child: Material(
          color: widget.buttonColor,
          borderRadius: BorderRadius.circular(16),
          elevation: 4,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary, width: 2.5),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(iconData, color: widget.labelColor, size: 22),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          labelText,
                          style: TextStyle(
                            color: widget.labelColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          statusSubtext,
                          style: TextStyle(
                            color: widget.labelColor.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveButton(
    BuildContext context,
    ColorScheme colorScheme,
    String labelText,
    VoidCallback? onPressed,
  ) {
    final String timeDisplay = _formatTime(_secondsElapsed);

    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Material(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: colorScheme.onSecondary, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Animate(
                  effects: const <Effect<dynamic>>[
                    FadeEffect(duration: Duration(milliseconds: 600)),
                  ],
                  onPlay: (AnimationController controller) =>
                      controller.repeat(reverse: true),
                  child: Icon(
                    LucideIcons.phoneForwarded,
                    color: colorScheme.onSecondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      timeDisplay,
                      style: TextStyle(
                        color: colorScheme.onSecondary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      labelText,
                      style: TextStyle(
                        color: colorScheme.onSecondary.withValues(alpha: 0.85),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
