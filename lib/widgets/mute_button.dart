import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/gri_button.dart';

class MuteButton extends StatelessWidget {
  const MuteButton({required this.isMuted, required this.onTap, super.key});

  final bool isMuted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GriButton(
      buttonName: 'MUTE',
      overrideLabel: isMuted ? '' : 'MUTE',
      icon: isMuted ? LucideIcons.volumeX : null,
      userRole: 'ALL',
      buttonStates: const <String, String>{},
      buttonInitiators: const <String, String>{},
      buttonDetails: const <String, String?>{},
      databaseService: DatabaseService(),
      buttonColor: isMuted
          ? colorScheme.primary
          : colorScheme.surfaceContainerHigh,
      labelColor: isMuted ? colorScheme.onPrimary : colorScheme.primary,
      onPressed: onTap,
    );
  }
}
