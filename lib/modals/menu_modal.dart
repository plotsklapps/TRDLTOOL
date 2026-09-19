import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/logic/modal_logic.dart';
import 'package:trdltool/modals/base_modal.dart';
import 'package:trdltool/modals/reload_modal.dart';
import 'package:trdltool/modals/theme_modal.dart';
import 'package:trdltool/modals/version_modal.dart';
import 'package:trdltool/signals/version_signal.dart';

class MenuModal extends SignalWidget {
  const MenuModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: 'Instellingen',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: const Text('Thema'),
            subtitle: const Text('Verander het uiterlijk van de app'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () async {
              await showModal(context: context, child: const ThemeModal());
            },
          ),
          ListTile(
            title: const Text('Over TRDLtool'),
            subtitle: const Text('Meer informatie over deze app'),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () async {
              await showModal(context: context, child: const VersionModal());
            },
          ),
          ListTile(
            title: Text('Versie: ${sVersion.value}'),
            subtitle: const Text(
              'Herlaad de app om nieuwe updates te installeren',
            ),
            trailing: const Icon(LucideIcons.chevronRight),
            onTap: () async {
              await showModal(context: context, child: const ReloadModal());
            },
          ),
        ],
      ),
    );
  }
}
