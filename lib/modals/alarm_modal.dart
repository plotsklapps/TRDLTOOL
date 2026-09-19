import 'package:firebase_database/firebase_database.dart';
import 'package:material_ui/material_ui.dart';
import 'package:trdltool/modals/base_modal.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/gri_button.dart';

Future<void> showAlarmModal({
  required BuildContext context,
  required String userRole,
  required String databasePath,
  required TextEditingController mcnController,
  required String title,
  required String hintText,
}) async {
  Future<void> handleAlarmAreaPressed(String area) async {
    await DatabaseService().saveButtonPress(
      'ALARM',
      userRole,
      'isCalling',
      details: area,
    );
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  await showModalBottomSheet<void>(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      if (userRole == 'LEERLING') {
        return BaseModal(
          title: 'Alarm Oproep',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Container()),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GriButton(
                      buttonName: 'NOORD',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('NOORD');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Container()),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: GriButton(
                      buttonName: 'WEST',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('WEST');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GriButton(
                      buttonName: 'CENTRUM',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('CENTRUM');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GriButton(
                      buttonName: 'OOST',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('OOST');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
                  Expanded(child: Container()),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GriButton(
                      buttonName: 'ZUID',
                      userRole: userRole,
                      buttonStates: const <String, String>{},
                      buttonInitiators: const <String, String>{},
                      buttonDetails: const <String, String?>{},
                      databaseService: DatabaseService(),
                      onPressed: () async {
                        await handleAlarmAreaPressed('ZUID');
                      },
                      buttonColor: Theme.of(context).colorScheme.primary,
                      labelColor: Theme.of(context).colorScheme.onPrimary,
                      progressIndicatorColor: Theme.of(
                        context,
                      ).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Container()),
                ],
              ),
            ],
          ),
        );
      } else {
        return StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref().child(databasePath).onValue,
          builder:
              (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
                final Map<String, String> buttonStates = <String, String>{};
                final Map<String, String> buttonInitiators = <String, String>{};
                final Map<String, String?> buttonDetails = <String, String?>{};

                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.snapshot.value != null) {
                  (snapshot.data!.snapshot.value! as Map<dynamic, dynamic>)
                      .forEach((dynamic key, dynamic value) {
                        if (value is Map) {
                          final Map<String, dynamic> buttonData =
                              Map<String, dynamic>.from(value);
                          final String? buttonName =
                              buttonData['buttonName'] as String?;
                          if (buttonName != null) {
                            buttonStates[buttonName] =
                                (buttonData['state'] as String?) ?? 'rest';
                            buttonInitiators[buttonName] =
                                (buttonData['initiator'] as String?) ?? '';
                            buttonDetails[buttonName] =
                                buttonData['details'] as String?;
                          }
                        }
                      });
                }

                return BaseModal(
                  title: title,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: mcnController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: hintText,
                          counterText: '',
                        ),
                      ),
                      const SizedBox(height: 16),
                      GriButton(
                        buttonName: 'ALARM',
                        overrideLabel: 'ALARMEER',
                        userRole: userRole,
                        buttonStates: buttonStates,
                        buttonInitiators: buttonInitiators,
                        buttonDetails: buttonDetails,
                        databaseService: DatabaseService(),
                        onPressed: () async {
                          final String details = mcnController.text;
                          if (details.isNotEmpty) {
                            await DatabaseService().saveButtonPress(
                              'ALARM',
                              userRole,
                              'isCalling',
                              details: details,
                            );
                          }
                        },
                        onCallEnded: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        buttonColor: Theme.of(context).colorScheme.primary,
                        labelColor: Theme.of(context).colorScheme.onPrimary,
                        progressIndicatorColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                      ),
                    ],
                  ),
                );
              },
        );
      }
    },
  );
}
