import 'package:firebase_database/firebase_database.dart';
import 'package:material_ui/material_ui.dart';
import 'package:trdltool/modals/base_modal.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/gri_button.dart';

Future<void> showMcnModal({
  required BuildContext context,
  required String userRole,
  required String databasePath,
  required TextEditingController mcnController,
  required String title,
  required String hintText,
}) async {
  await showModalBottomSheet<void>(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return StreamBuilder<DatabaseEvent>(
        stream: FirebaseDatabase.instance.ref().child(databasePath).onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          final Map<String, String> buttonStates = <String, String>{};
          final Map<String, String> buttonInitiators = <String, String>{};
          final Map<String, String?> buttonDetails = <String, String?>{};

          if (snapshot.hasData &&
              snapshot.data != null &&
              snapshot.data!.snapshot.value != null) {
            (snapshot.data!.snapshot.value! as Map<dynamic, dynamic>).forEach((
              dynamic key,
              dynamic value,
            ) {
              if (value is Map) {
                final Map<String, dynamic> buttonData =
                    Map<String, dynamic>.from(value);
                final String? buttonName = buttonData['buttonName'] as String?;
                if (buttonName != null) {
                  buttonStates[buttonName] =
                      (buttonData['state'] as String?) ?? 'rest';
                  buttonInitiators[buttonName] =
                      (buttonData['initiator'] as String?) ?? '';
                  buttonDetails[buttonName] = buttonData['details'] as String?;
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
                  buttonName: 'MCN',
                  userRole: userRole,
                  buttonStates: buttonStates,
                  buttonInitiators: buttonInitiators,
                  buttonDetails: buttonDetails,
                  databaseService: DatabaseService(),
                  onPressed: () async {
                    final String details = mcnController.text;
                    if (details.isNotEmpty) {
                      await DatabaseService().saveButtonPress(
                        'MCN',
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
    },
  );
}
