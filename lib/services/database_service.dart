import 'dart:async';
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:signals/signals.dart';
import 'package:trdltool/services/timer_service.dart';

// Create sCodeOpleider Signal.
final Signal<String> sCodeOpleider = Signal<String>(
  'ABC00',
  options: const SignalOptions<String>(name: 'sCodeOpleider'),
);

// Create sCodeLeerling Signal.
final Signal<String> sCodeLeerling = Signal<String>(
  'ABC00',
  options: const SignalOptions<String>(name: 'sCodeLeerling'),
);

class DatabaseService {
  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  static final DatabaseService _instance = DatabaseService._internal();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final TimerService _timerService = TimerService();
  final Logger _logger = Logger();

  // Generate code shared between teacher and student.
  void generateCode() {
    const String characters = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final String newCode = List<String>.generate(5, (int index) {
      // Returns for example: ABC12.
      return characters[Random().nextInt(characters.length)];
    }).join();

    // Set the Signal.
    sCodeOpleider.value = newCode;

    // Start the timer (5 min).
    _timerService.startTimer(generateCode);
  }

  Future<void> saveCodeToDatabase() async {
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final Map<String, dynamic> codeData = <String, dynamic>{
      'createdAt': now.toIso8601String(),
    };

    // Initial button states.
    final List<String> buttonNames = <String>[
      'MKS ALARM',
      'MKS INFO',
      'AL',
      'OBI',
      'DVL',
      'BuurTRDL',
      'Mdw Rangeren',
      'CRA',
      'Brugwachter',
      'MCN 3064',
      'Overig',
      'ALARM',
      'ALGEMEEN',
      'BEL MCN',
    ];
    final Map<String, dynamic> buttons = <String, dynamic>{
      for (final String name in buttonNames)
        // Set initial state for all buttons.
        name: <String, String?>{
          'buttonName': name,
          'state': 'rest',
          'initiator': null,
          'timestamp': null,
          'details': null,
        },
    };

    // Save the initial button configurations.
    await _database.child('$formattedDate/${sCodeOpleider.value}').set(
      <String, dynamic>{
        ...codeData,
        'buttons': buttons,
      },
    );
  }

  Future<bool> validateCodeFromDatabase(String enteredCode) async {
    final DateTime currentTime = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(currentTime);

    try {
      // Fetch data snapshot for entered code and date.
      final DatabaseEvent event = await _database
          .child('$formattedDate/$enteredCode')
          .once();

      // Fetch the actual snapshot from event.
      final DataSnapshot codeSnapshot = event.snapshot;

      if (codeSnapshot.exists && codeSnapshot.value != null) {
        // Convert snapshot value to Map.
        final Map<String, dynamic> codeData = Map<String, dynamic>.from(
          codeSnapshot.value! as Map<Object?, Object?>,
        );

        // Extract creation timestamp String.
        final String? createdAtString = codeData['createdAt'] as String?;

        if (createdAtString != null) {
          try {
            // Convert String to DateTime.
            final DateTime createdAt = DateTime.parse(createdAtString);

            // Return Duration.
            return currentTime.difference(createdAt).inMinutes <= 5;
          } on Exception catch (e, s) {
            // Log the error.
            _logger.e('Error parsing createdAt date: $e\n$s');

            return false;
          }
        }
      }
    } on Exception catch (e, s) {
      // Log the error.
      _logger.e('Error fetching code from database: $e\n$s');

      return false;
    }
    return false;
  }

  Future<void> saveButtonPress(
    String buttonName,
    String caller,
    String state, {
    String? details,
  }) async {
    // Log buttonpress (useful for debugging).
    Logger().i(
      'Button pressed: $buttonName, Details: $details, Caller: $caller, New '
      'state: $state,',
    );

    // Log the initiation of a call to Firebase Analytics to track button usage.
    // We only log 'isCalling' to avoid duplicate events for a single action.
    if (state == 'isCalling') {
      unawaited(
        FirebaseAnalytics.instance.logEvent(
          name: 'call_initiated',
          parameters: <String, Object>{
            'button_name': buttonName,
            'user_role': caller,
          },
        ),
      );
    }

    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final String formattedTime = DateFormat('HH:mm:ss').format(now);

    final Map<String, dynamic> buttonData = <String, dynamic>{
      'buttonName': buttonName,
      'state': state, // 'rest', 'calling', 'called', 'active'.
      'initiator': caller, // 'opleider' or 'leerling'.
      'timestamp': formattedTime, // always set for simplicity.
      'details': details, // Can be MCN number, alarm area, etc.
    };

    // Determine the correct code to use based on the caller's role.
    final String code = (caller == 'LEERLING')
        ? sCodeLeerling.value
        : sCodeOpleider.value;

    // Use buttonName as the key so both parties update the same button
    // entry under the correct code.
    await _database
        .child('$formattedDate/$code/buttons/$buttonName')
        .set(buttonData);
  }
}
