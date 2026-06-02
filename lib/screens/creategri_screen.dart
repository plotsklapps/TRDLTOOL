import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/screens/teacher_screen.dart';
import 'package:trdltool/services/database_service.dart';
import 'package:trdltool/services/timer_service.dart';

class CreateGRIScreen extends SignalWidget {
  const CreateGRIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DatabaseService databaseService = DatabaseService();
    final TimerService timerService = TimerService();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nieuwe GRI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  _formatTime(sTimer.value),
                  style: const TextStyle(fontSize: 20, color: Colors.red),
                ),
                const SizedBox(width: 36),
                IconButton(
                  onPressed: databaseService.generateCode,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text(
              'Geef onderstaande code aan de leerling\nen druk op de button.'
              '\n\nLet op HOOFDLETTERS.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Text(
              sCodeOpleider.value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    await databaseService.saveCodeToDatabase();

                    timerService.cancelTimer();

                    if (context.mounted) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) {
                            return const TeacherScreen();
                          },
                        ),
                      );
                    }
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
                      child: const Center(child: Text('Creëer GRI')),
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

  String _formatTime(int seconds) {
    final int minutes = seconds ~/ 60;
    final int secs = seconds % 60;
    final DateTime time = DateTime(0, 0, 0, 0, minutes, secs);
    return DateFormat('mm:ss').format(time);
  }
}
