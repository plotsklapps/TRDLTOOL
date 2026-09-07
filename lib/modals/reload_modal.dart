import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:trdltool/modals/base_modal.dart';
import 'package:trdltool/signals/version_signal.dart';
import 'package:web/web.dart' as web;

class ReloadModal extends SignalWidget {
  const ReloadModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseModal(
      title: 'App Herladen',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Huidige versie: ${sVersion.value}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            'Het herladen van de app duurt slechts een paar seconden.\n'
            'Daarna draait automatisch de laatste versie van TRDLtool.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 80,
            child: Material(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              elevation: 2,
              child: InkWell(
                onTap: () {
                  web.window.location.reload();
                },
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: Text(
                    'HERLAAD APP',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
