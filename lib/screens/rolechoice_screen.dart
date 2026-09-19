import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:material_ui/material_ui.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trdltool/logic/modal_logic.dart';
import 'package:trdltool/modals/menu_modal.dart';
import 'package:trdltool/screens/activategri_screen.dart';
import 'package:trdltool/screens/creategri_screen.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:web/web.dart' as web;

class RoleChoiceScreen extends StatefulWidget {
  const RoleChoiceScreen({super.key});

  @override
  State<RoleChoiceScreen> createState() {
    return _RoleChoiceScreenState();
  }
}

class _RoleChoiceScreenState extends State<RoleChoiceScreen> {
  @override
  void initState() {
    super.initState();
    _setAppDisplayModeProperty();
  }

  void _setAppDisplayModeProperty() {
    final bool isStandalone = web.window
        .matchMedia('(display-mode: standalone)')
        .matches;
    final String displayMode = isStandalone ? 'standalone' : 'browser';
    unawaited(
      FirebaseAnalytics.instance.setUserProperty(
        name: 'app_display_mode',
        value: displayMode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,

        title: const Text(
          'TRDLtool',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await showModal(context: context, child: const MenuModal());
            },
            icon: const Icon(LucideIcons.menu),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Ik ben...'),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    // Set the user role property for analytics.
                    unawaited(
                      FirebaseAnalytics.instance.setUserProperty(
                        name: 'user_role',
                        value: 'OPLEIDER',
                      ),
                    );

                    databaseService.generateCode();

                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const CreateGRIScreen();
                        },
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 160,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // InkWell provides the tap effect.
                      child: const Center(child: Text('Opleider')),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    // Set the user role property for analytics.
                    unawaited(
                      FirebaseAnalytics.instance.setUserProperty(
                        name: 'user_role',
                        value: 'LEERLING',
                      ),
                    );

                    await Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const ActivateGRIScreen();
                        },
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 160,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // InkWell provides the tap effect.
                      child: Center(
                        child: Text(
                          'Leerling',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
