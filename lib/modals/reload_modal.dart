import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/signals/version_signal.dart';
import 'package:web/web.dart' as web;

class ReloadModal extends SignalWidget {
  const ReloadModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Huidige versie: ${sVersion.value}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              'Het herladen van de app duurt slechts een paar seconden.\n'
              'Daarna draait automatisch de laatste versie van TRDLtool.',
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Pop the bottomsheet.
                      Navigator.pop(context);
                    },
                    child: const Text('Annuleren'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      web.window.location.reload();
                    },
                    child: const Text('Herlaad'),
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
