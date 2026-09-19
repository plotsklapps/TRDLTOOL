import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:material_ui/material_ui.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/logic/modal_logic.dart';
import 'package:trdltool/modals/alarm_modal.dart';
import 'package:trdltool/modals/base_modal.dart';
import 'package:trdltool/modals/dei_modal.dart';
import 'package:trdltool/modals/general_modal.dart';
import 'package:trdltool/modals/mcn_modal.dart';
import 'package:trdltool/modals/theme_modal.dart';
import 'package:trdltool/models/dei_model.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/widgets/dei_button.dart';
import 'package:trdltool/widgets/gri_button.dart';
import 'package:trdltool/widgets/gri_status_display.dart';
import 'package:trdltool/widgets/mute_button.dart';

class TeacherScreen extends SignalStatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() {
    return _TeacherScreenState();
  }
}

class _TeacherScreenState extends State<TeacherScreen> {
  final AudioPlayer _mcnAlarmtoonPlayer = AudioPlayer();
  final AudioPlayer _boAlarmtoonPlayer = AudioPlayer();
  final AudioPlayer _beltoonPlayer = AudioPlayer();
  Map<String, String> _previousButtonStates = <String, String>{};
  final TextEditingController _mcnController = TextEditingController();
  final TextEditingController _alarmMcnController = TextEditingController();
  bool _isMuted = false;

  final Set<String> _promptedDeiIds = <String>{};
  final Set<String> _promptedIdNumDeiIds = <String>{};

  void _handleDeiNotifications(List<DeiModel> deiList) {
    for (final DeiModel dei in deiList) {
      if (dei.status == 'sent' && !_promptedDeiIds.contains(dei.id)) {
        _promptedDeiIds.add(dei.id);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(_showIncomingDeiModal(dei));
        });
      } else if (dei.status == 'id_sent' &&
          !_promptedIdNumDeiIds.contains(dei.id)) {
        _promptedIdNumDeiIds.add(dei.id);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(_showIdentificatienummerModal(dei));
        });
      }
    }
  }

  Future<void> _showIncomingDeiModal(DeiModel dei) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext modalContext) {
        final ColorScheme colorScheme = Theme.of(modalContext).colorScheme;

        String routeSummary = '';
        if (dei.emplacementVan != null && dei.emplacementVan!.isNotEmpty) {
          if (dei.emplacementTot != null && dei.emplacementTot!.isNotEmpty) {
            routeSummary =
                'Traject: ${dei.emplacementVan} - ${dei.emplacementTot}';
          } else {
            routeSummary = 'Emplacement: ${dei.emplacementVan}';
          }
        } else if (dei.emplacementTot != null &&
            dei.emplacementTot!.isNotEmpty) {
          routeSummary = 'Emplacement: ${dei.emplacementTot}';
        }

        String kmSummary = '';
        if (dei.kilometerVan != null && dei.kilometerVan!.isNotEmpty) {
          if (dei.kilometerTot != null && dei.kilometerTot!.isNotEmpty) {
            kmSummary = 'Kilometers: ${dei.kilometerVan} - ${dei.kilometerTot}';
          } else {
            kmSummary = 'Kilometer: ${dei.kilometerVan}';
          }
        } else if (dei.kilometerTot != null && dei.kilometerTot!.isNotEmpty) {
          kmSummary = 'Kilometer: ${dei.kilometerTot}';
        }

        return BaseModal(
          title: 'Nieuwe DEI ${dei.deiType}',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Bestemd voor Trein ${dei.treinnummer}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              if (dei.seinnummer != null && dei.seinnummer!.isNotEmpty)
                Text('Seinnummer: ${dei.seinnummer}'),
              if (routeSummary.isNotEmpty) Text(routeSummary),
              if (kmSummary.isNotEmpty) Text(kmSummary),
              if (dei.infraControlerenReden != null &&
                  dei.infraControlerenReden!.isNotEmpty)
                Text('Reden: ${dei.infraControlerenReden}'),
              if (dei.overwegen != null && dei.overwegen!.isNotEmpty)
                Text('Overwegen: ${dei.overwegen!.join(", ")}'),
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Material(
                        color: colorScheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 1,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(modalContext);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colorScheme.outline,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  LucideIcons.pause,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Pauzeren / Later',
                                    style: TextStyle(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: Material(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        elevation: 2,
                        child: InkWell(
                          onTap: () async {
                            Navigator.pop(modalContext);
                            await DatabaseService().updateDeiStatus(
                              dei.id,
                              'OPLEIDER',
                              'isCalling',
                            );
                            if (modalContext.mounted) {
                              await showDeiModal(
                                context: modalContext,
                                userRole: 'OPLEIDER',
                                existingDei: dei.copyWith(status: 'isCalling'),
                              );
                            }
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                LucideIcons.phoneIncoming,
                                color: colorScheme.onPrimary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Aannemen',
                                  style: TextStyle(
                                    color: colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showIdentificatienummerModal(DeiModel dei) async {
    if (!mounted) return;
    await showModalBottomSheet<void>(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext modalContext) {
        final ColorScheme colorScheme = Theme.of(modalContext).colorScheme;

        return BaseModal(
          title: 'Identificatienummer DEI ${dei.deiType}',
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Identificatienummer voor DEI ${dei.deiType} '
                '(Trein ${dei.treinnummer}):',
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.primary, width: 2),
                ),
                child: Center(
                  child: Text(
                    dei.identificatienummer ?? '',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Lees dit identificatienummer terug aan de TRDL.',
                textAlign: TextAlign.center,
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Material(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  elevation: 2,
                  child: InkWell(
                    onTap: () async {
                      Navigator.pop(modalContext);
                      await DatabaseService().updateDeiStatus(
                        dei.id,
                        'OPLEIDER',
                        'completed',
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          LucideIcons.check,
                          color: colorScheme.onPrimary,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'BEGREPEN & AFGEROND',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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
    _alarmMcnController.dispose();
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
    const String userRole = 'OPLEIDER';

    // Iterate over all buttons to check for state changes.
    newButtonStates.forEach((String buttonName, String newState) async {
      final String? previousState = _previousButtonStates[buttonName];
      final String? initiator = newButtonInitiators[buttonName];

      // A button is being called, and this user is not the one who started it.
      if (newState == 'isCalling' &&
          previousState != 'isCalling' &&
          initiator != userRole) {
        final double volume = _isMuted ? 0.0 : 1.0;
        // Decide which sound to play based on the button name.
        if (buttonName == 'ALARM') {
          await _mcnAlarmtoonPlayer.setVolume(volume);
          await _mcnAlarmtoonPlayer.play();
        } else if (buttonName == 'MKS ALARM') {
          await _boAlarmtoonPlayer.setVolume(volume);
          await _boAlarmtoonPlayer.play();
        } else {
          await _beltoonPlayer.setVolume(volume);
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
    final String path = '$formattedDate/${sCodeOpleider.value}/buttons';

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
              'OPLEIDER GRI ${sCodeOpleider.value}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            actions: <Widget>[
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
                GriStatusDisplay(statusText: statusText),
                StreamBuilder<DatabaseEvent>(
                  stream: database
                      .child('$formattedDate/${sCodeOpleider.value}/deis')
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
                              if (dei.status != 'completed' &&
                                  dei.status != 'cancelled') {
                                deiList.add(dei);
                              }
                            }
                          }
                          deiList.sort(
                            (DeiModel a, DeiModel b) => b.id.compareTo(a.id),
                          );
                        }

                        _handleDeiNotifications(deiList);

                        if (deiList.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 12),
                            const Text(
                              'ONTVANGEN VOORSCHRIFTEN (DEI)',
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
                                  userRole: 'OPLEIDER',
                                  onTap: () async {
                                    if (dei.status == 'sent') {
                                      await DatabaseService().updateDeiStatus(
                                        dei.id,
                                        'OPLEIDER',
                                        'isCalling',
                                      );
                                    }
                                    if (context.mounted) {
                                      await showDeiModal(
                                        context: context,
                                        userRole: 'OPLEIDER',
                                        existingDei: dei.copyWith(
                                          status: 'isCalling',
                                        ),
                                      );
                                    }
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
                          GriButton(
                            buttonName: 'MKS ALARM',
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                            buttonColor: Theme.of(context).colorScheme.primary,
                            labelColor: Theme.of(context).colorScheme.onPrimary,
                          ),
                          const SizedBox(height: 8),
                          GriButton(
                            buttonName: 'MKS INFO',
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            labelColor: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          GriButton(
                            buttonName: 'AL',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          GriButton(
                            buttonName: 'OBI',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          GriButton(
                            buttonName: 'DVL',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            userRole: 'OPLEIDER',
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
                          GriButton(
                            buttonName: 'Tunnel Operator',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          GriButton(
                            buttonName: 'BuurTRDL',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          GriButton(
                            buttonName: 'Mdw Rangeren',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          GriButton(
                            buttonName: 'Brugwachter',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                          ),
                          const SizedBox(height: 8),
                          GriButton(
                            buttonName: 'MCN',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            labelColor: Theme.of(context).colorScheme.primary,
                            userRole: 'OPLEIDER',
                            buttonStates: buttonStates,
                            buttonInitiators: buttonInitiators,
                            buttonDetails: buttonDetails,
                            databaseService: databaseService,
                            onPressed: () async {
                              await showMcnModal(
                                context: context,
                                userRole: 'OPLEIDER',
                                databasePath: path,
                                mcnController: _mcnController,
                                title: 'Bel naar MCN...',
                                hintText: 'TREIN',
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          GriButton(
                            buttonName: 'Overig',
                            buttonColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            labelColor: Theme.of(context).colorScheme.primary,
                            userRole: 'OPLEIDER',
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
                      child: GriButton(
                        buttonName: 'ALARM',
                        userRole: 'OPLEIDER',
                        buttonStates: buttonStates,
                        buttonInitiators: buttonInitiators,
                        buttonDetails: buttonDetails,
                        databaseService: databaseService,
                        buttonColor: Theme.of(context).colorScheme.primary,
                        labelColor: Theme.of(context).colorScheme.onPrimary,
                        onPressed: () async {
                          await showAlarmModal(
                            context: context,
                            userRole: 'OPLEIDER',
                            databasePath: path,
                            mcnController: _alarmMcnController,
                            title: 'Alarmgebied',
                            hintText: 'Kies gebied',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GriButton(
                        buttonName: 'ALGEMEEN',
                        userRole: 'OPLEIDER',
                        buttonStates: buttonStates,
                        buttonInitiators: buttonInitiators,
                        buttonDetails: buttonDetails,
                        databaseService: databaseService,
                        buttonColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                        labelColor: Theme.of(context).colorScheme.primary,
                        onPressed: () async {
                          await showGeneralModal(
                            context: context,
                            userRole: 'OPLEIDER',
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
