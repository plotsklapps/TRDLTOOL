import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/logic/modal_logic.dart';
import 'package:trdltool/modals/dei_modal.dart';
import 'package:trdltool/modals/theme_modal.dart';
import 'package:trdltool/models/dei_model.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/alarm_button.dart';
import 'package:trdltool/widgets/alarm_call_sheet.dart';
import 'package:trdltool/widgets/dei_button.dart';
import 'package:trdltool/widgets/general_button.dart';
import 'package:trdltool/widgets/general_call_sheet.dart';
import 'package:trdltool/widgets/mcn_button.dart';
import 'package:trdltool/widgets/mcn_call_sheet.dart';
import 'package:trdltool/widgets/mute_button.dart';
import 'package:trdltool/widgets/phone_button.dart';

class StudentScreen extends SignalStatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() {
    return _StudentScreenState();
  }
}

class _StudentScreenState extends State<StudentScreen> {
  final AudioPlayer _mcnAlarmtoonPlayer = AudioPlayer();
  final AudioPlayer _boAlarmtoonPlayer = AudioPlayer();
  final AudioPlayer _beltoonPlayer = AudioPlayer();
  Map<String, String> _previousButtonStates = <String, String>{};
  final TextEditingController _mcnController = TextEditingController();
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    unawaited(preloadAssets());
  }

  @override
  Future<void> dispose() async {
    // Stop and release the audio player's resources when the screen
    // is disposed.
    await _mcnAlarmtoonPlayer.dispose();
    await _boAlarmtoonPlayer.dispose();
    await _beltoonPlayer.dispose();
    _mcnController.dispose();
    super.dispose();
  }

  Future<void> preloadAssets() async {
    // Pre-load the phone sounds for faster playback.
    await _mcnAlarmtoonPlayer.setAsset('assets/wav/mcn_alarm.wav');
    await _boAlarmtoonPlayer.setAsset('assets/wav/bo_alarm.wav');
    await _beltoonPlayer.setAsset('assets/wav/beltoon.wav');
    // Set the release mode to loop so the sound plays continuously.
    await _mcnAlarmtoonPlayer.setLoopMode(LoopMode.one);
    await _boAlarmtoonPlayer.setLoopMode(LoopMode.one);
    await _beltoonPlayer.setLoopMode(LoopMode.one);
  }

  void _handleButtonStateChanges(
    Map<String, String> newButtonStates,
    Map<String, String> newButtonInitiators,
  ) {
    const String userRole = 'LEERLING';

    // Iterate over all buttons to check for state changes.
    newButtonStates.forEach((String buttonName, String newState) async {
      final String? previousState = _previousButtonStates[buttonName];
      final String? initiator = newButtonInitiators[buttonName];

      // A button is being called, and this user is not the one who started it.
      if (newState == 'isCalling' &&
          previousState != 'isCalling' &&
          initiator != userRole) {
        // Decide which sound to play based on the button name.
        if (buttonName == 'ALARM') {
          await _mcnAlarmtoonPlayer.play();
        } else if (buttonName == 'MKS ALARM') {
          await _boAlarmtoonPlayer.play();
        } else {
          await _beltoonPlayer.play();
        }
      }
      // A call was answered or cancelled.
      else if (newState != 'isCalling' && previousState == 'isCalling') {
        // Stop the corresponding player.
        if (buttonName == 'ALARM') {
          await _mcnAlarmtoonPlayer.stop();
        } else if (buttonName == 'MKS ALARM') {
          await _boAlarmtoonPlayer.stop();
        } else {
          await _beltoonPlayer.stop();
        }
      }
    });

    // Update the previous states for the next comparison.
    _previousButtonStates = Map<String, String>.from(newButtonStates);
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      final double volume = _isMuted ? 0.0 : 1.0;
      unawaited(_mcnAlarmtoonPlayer.setVolume(volume));
      unawaited(_boAlarmtoonPlayer.setVolume(volume));
      unawaited(_beltoonPlayer.setVolume(volume));
    });
  }

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final DatabaseReference database = FirebaseDatabase.instance.ref();
    final String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
    final String path = '$formattedDate/${sCodeLeerling.value}/buttons';

    return StreamBuilder<DatabaseEvent>(
      stream: database.child(path).onValue,
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
              final Map<String, dynamic> buttonData = Map<String, dynamic>.from(
                value,
              );
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
          // After parsing the new data, check for the state change.
          _handleButtonStateChanges(buttonStates, buttonInitiators);
        }

        String statusText = 'GEEN ACTIEVE OPROEP';

        for (final MapEntry<String, String> entry in buttonStates.entries) {
          if (entry.value == 'isActive') {
            statusText = entry.key;
            // Only one call can be active at a time.
            break;
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'LEERLING GRI ${sCodeLeerling.value}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: FilledButton.icon(
                  onPressed: () async {
                    await showDeiModal(context: context, userRole: 'LEERLING');
                  },
                  icon: const Icon(LucideIcons.fileText, size: 18),
                  label: const Text(
                    'DEI',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              IconButton(
                onPressed: () async {
                  await showModal(context: context, child: const ThemeModal());
                },
                icon: const Icon(LucideIcons.menu),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).disabledColor,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        statusText.toUpperCase(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                StreamBuilder<DatabaseEvent>(
                  stream: database
                      .child('$formattedDate/${sCodeLeerling.value}/deis')
                      .onValue,
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<DatabaseEvent> deiSnapshot,
                      ) {
                        final List<DeiModel> deiList = <DeiModel>[];
                        if (deiSnapshot.hasData &&
                            deiSnapshot.data?.snapshot.value != null) {
                          final Map<dynamic, dynamic> rawMap =
                              deiSnapshot.data!.snapshot.value!
                                  as Map<dynamic, dynamic>;
                          for (final MapEntry<dynamic, dynamic> entry
                              in rawMap.entries) {
                            if (entry.value is Map) {
                              final DeiModel dei = DeiModel.fromMap(
                                entry.key.toString(),
                                Map<String, dynamic>.from(
                                  entry.value as Map<dynamic, dynamic>,
                                ),
                              );
                              if (dei.status != 'cancelled') {
                                deiList.add(dei);
                              }
                            }
                          }
                          deiList.sort(
                            (DeiModel a, DeiModel b) => b.id.compareTo(a.id),
                          );
                        }

                        if (deiList.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 12),
                            const Text(
                              'UITGEGEVEN VOORSCHRIFTEN (DEI)',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...deiList.map((DeiModel dei) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: DeiButton(
                                  dei: dei,
                                  userRole: 'LEERLING',
                                  onTap: () async {
                                    await showDeiModal(
                                      context: context,
                                      userRole: 'LEERLING',
                                      existingDei: dei,
                                    );
                                  },
                                ),
                              );
                            }),
                          ],
                        );
                      },
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          PhoneButton(
                            buttonName: 'MKS ALARM',
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                            buttonColor: Theme.of(context).colorScheme.primary,
                            labelColor: Theme.of(context).colorScheme.onPrimary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'MKS INFO',
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'AL',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'OBI',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'DVL',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          MuteButton(isMuted: _isMuted, onTap: _toggleMute),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          PhoneButton(
                            buttonName: 'Tunnel Operator',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'BuurTRDL',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'Mdw Rangeren',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'Brugwachter',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          McnButton(
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                            onShowMcnCallSheet: () async {
                              await showMcnCallSheet(
                                context: context,
                                userRole: 'LEERLING',
                                databasePath: path,
                                mcnController: _mcnController,
                                title: 'Bel naar MCN...',
                                hintText: 'TREIN',
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          PhoneButton(
                            buttonName: 'Overig',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            progressIndicatorColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            userRole: 'LEERLING',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: AlarmButton(
                        userRole: 'LEERLING',
                        buttonStates: buttonStates,
                        buttonInitiators: buttonInitiators,
                        buttonDetails: buttonDetails,
                        databaseService: databaseService,
                        onPressed: () async {
                          await showAlarmCallSheet(
                            context: context,
                            userRole: 'LEERLING',
                            databasePath: path,
                            mcnController: _mcnController,
                            title: 'Alarmgebied',
                            hintText: 'Kies gebied',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GeneralButton(
                        userRole: 'LEERLING',
                        buttonStates: buttonStates,
                        buttonInitiators: buttonInitiators,
                        buttonDetails: buttonDetails,
                        databaseService: databaseService,
                        onPressed: () async {
                          await showGeneralCallSheet(
                            context: context,
                            userRole: 'LEERLING',
                            databasePath: path,
                            mcnController: _mcnController,
                            title: 'Algemene Oproep',
                            hintText: 'Kies gebied',
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
