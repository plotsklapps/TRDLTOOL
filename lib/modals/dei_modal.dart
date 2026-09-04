import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:trdltool/models/dei_model.dart';
import 'package:trdltool/services/database_service.dart';

Future<void> showDeiModal({
  required BuildContext context,
  required String userRole,
  DeiModel? existingDei,
}) async {
  await showModalBottomSheet<void>(
    showDragHandle: true,
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return DeiModal(userRole: userRole, existingDei: existingDei);
    },
  );
}

class DeiModal extends StatefulWidget {
  const DeiModal({required this.userRole, this.existingDei, super.key});

  final String userRole;
  final DeiModel? existingDei;

  @override
  State<DeiModal> createState() {
    return _DeiModalState();
  }
}

class _DeiModalState extends State<DeiModal> {
  late String _selectedDeiType;
  late TextEditingController _treinnummerController;
  late TextEditingController _maxSnelheidController;
  late TextEditingController _emplacementVanController;
  late TextEditingController _emplacementTotController;
  late TextEditingController _kilometerVanController;
  late TextEditingController _kilometerTotController;
  late TextEditingController _bijzonderhedenController;
  late TextEditingController _meldenAanController;
  late TextEditingController _idNummerController;

  bool get _isCreationMode => widget.existingDei == null;
  bool get _isTRDL => widget.userRole == 'LEERLING';

  @override
  void initState() {
    super.initState();
    final DeiModel? dei = widget.existingDei;

    _selectedDeiType = dei?.deiType ?? '6';
    _treinnummerController = TextEditingController(
      text: dei?.treinnummer ?? '',
    );
    _maxSnelheidController = TextEditingController(
      text: dei?.maxSnelheid ?? '40 km/h',
    );
    _emplacementVanController = TextEditingController(
      text: dei?.emplacementVan ?? '',
    );
    _emplacementTotController = TextEditingController(
      text: dei?.emplacementTot ?? '',
    );
    _kilometerVanController = TextEditingController(
      text: dei?.kilometerVan ?? '',
    );
    _kilometerTotController = TextEditingController(
      text: dei?.kilometerTot ?? '',
    );
    _bijzonderhedenController = TextEditingController(
      text: dei?.bijzonderheden ?? '',
    );
    _meldenAanController = TextEditingController(
      text: dei?.meldenAan ?? 'TRDL',
    );

    // Default auto-generated identificatienummer: [Treinnummer][HHmm]
    final String defaultId = _generateDefaultIdNumber(dei?.treinnummer ?? '');
    _idNummerController = TextEditingController(
      text: dei?.identificatienummer ?? defaultId,
    );
  }

  @override
  void dispose() {
    _treinnummerController.dispose();
    _maxSnelheidController.dispose();
    _emplacementVanController.dispose();
    _emplacementTotController.dispose();
    _kilometerVanController.dispose();
    _kilometerTotController.dispose();
    _bijzonderhedenController.dispose();
    _meldenAanController.dispose();
    _idNummerController.dispose();
    super.dispose();
  }

  String _generateDefaultIdNumber(String trainNumber) {
    final String nowTime = DateFormat('HHmm').format(DateTime.now());
    if (trainNumber.isEmpty) {
      return nowTime;
    }
    return '$trainNumber$nowTime';
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isReadOnly = !_isTRDL || !_isCreationMode;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        left: 16,
        right: 16,
        top: 8,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  _isCreationMode
                      ? 'Nieuw Voorschrift (DEI)'
                      : 'DEI $_selectedDeiType - '
                            'Trein ${_treinnummerController.text}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (widget.existingDei != null)
                  Chip(
                    label: Text(
                      widget.existingDei!.status.toUpperCase(),
                      style: const TextStyle(fontSize: 11),
                    ),
                    backgroundColor: colorScheme.primaryContainer,
                  ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            // DEI ChoiceChips (1 t/m 8)
            const Text(
              'Selecteer DEI Type:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List<Widget>.generate(8, (int index) {
                  final String number = '${index + 1}';
                  final bool isSelected = _selectedDeiType == number;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(
                        'DEI $number',
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? colorScheme.onPrimary : null,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: colorScheme.primary,
                      onSelected: isReadOnly
                          ? null
                          : (bool selected) {
                              if (selected) {
                                setState(() {
                                  _selectedDeiType = number;
                                });
                              }
                            },
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            // Treinnummer & Max Snelheid
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _treinnummerController,
                    enabled: !isReadOnly,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    onChanged: (String val) {
                      if (_isCreationMode) {
                        _idNummerController.text = _generateDefaultIdNumber(
                          val,
                        );
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Treinnummer (MCN)',
                      hintText: 'bijv. 47705',
                      counterText: '',
                      prefixIcon: Icon(LucideIcons.trainTrack),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _maxSnelheidController,
                    enabled: !isReadOnly,
                    decoration: const InputDecoration(
                      labelText: 'Max Snelheid',
                      hintText: 'bijv. 40 km/h',
                      prefixIcon: Icon(LucideIcons.gauge),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Emplacement Van / Tot
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _emplacementVanController,
                    enabled: !isReadOnly,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Van Emplacement',
                      hintText: 'bijv. Amr / Alkmaar',
                      prefixIcon: Icon(LucideIcons.mapPin),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _emplacementTotController,
                    enabled: !isReadOnly,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Tot Emplacement',
                      hintText: 'bijv. Utg / Uitgeest',
                      prefixIcon: Icon(LucideIcons.mapPinOff),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Kilometer Van / Tot
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _kilometerVanController,
                    enabled: !isReadOnly,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Van Kilometer',
                      hintText: 'bijv. 43.0',
                      prefixIcon: Icon(LucideIcons.ruler),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _kilometerTotController,
                    enabled: !isReadOnly,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Tot Kilometer',
                      hintText: 'bijv. 44.0',
                      prefixIcon: Icon(LucideIcons.ruler),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Bijzonderheden
            TextField(
              controller: _bijzonderhedenController,
              enabled: !isReadOnly,
              decoration: const InputDecoration(
                labelText: 'Bijzonderheden',
                hintText: 'bijv. Spoorlopers langs het spoor',
                prefixIcon: Icon(LucideIcons.triangleAlert),
              ),
            ),
            const SizedBox(height: 12),

            // Melden aan
            TextField(
              controller: _meldenAanController,
              enabled: !isReadOnly,
              decoration: const InputDecoration(
                labelText: 'Melden aan',
                hintText: 'bijv. TRDL',
                prefixIcon: Icon(LucideIcons.userCheck),
              ),
            ),
            const SizedBox(height: 20),

            // Identificatienummer section for TRDL when DEI is active
            if (_isTRDL && !_isCreationMode) ...<Widget>[
              const Divider(),
              const SizedBox(height: 8),
              TextField(
                controller: _idNummerController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Identificatienummer (Trein + Tijd)',
                  hintText: 'bijv. 477051250',
                  prefixIcon: Icon(LucideIcons.keyRound),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Action Buttons
            if (_isCreationMode && _isTRDL) ...<Widget>[
              ElevatedButton.icon(
                onPressed: _submitDei,
                icon: const Icon(LucideIcons.send),
                label: const Text('Verstuur DEI naar MCN'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ] else ...<Widget>[
              if (_isTRDL) ...<Widget>[
                ElevatedButton.icon(
                  onPressed: _sendIdentificatienummer,
                  icon: const Icon(LucideIcons.checkCheck),
                  label: const Text('Verstuur Identificatienummer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _cancelDei,
                  icon: const Icon(LucideIcons.trash2),
                  label: const Text('DEI Annuleren'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ] else ...<Widget>[
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.check),
                  label: const Text('Teruggelezen / Sluiten'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ],
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _submitDei() async {
    final String trein = _treinnummerController.text.trim();
    if (trein.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vul a.u.b. een treinnummer in.')),
      );
      return;
    }

    final String nowTime = DateFormat('HH:mm').format(DateTime.now());
    final String deiId = 'dei_${DateTime.now().millisecondsSinceEpoch}';

    final DeiModel dei = DeiModel(
      id: deiId,
      deiType: _selectedDeiType,
      treinnummer: trein,
      maxSnelheid: _maxSnelheidController.text.trim(),
      emplacementVan: _emplacementVanController.text.trim(),
      emplacementTot: _emplacementTotController.text.trim(),
      kilometerVan: _kilometerVanController.text.trim(),
      kilometerTot: _kilometerTotController.text.trim(),
      bijzonderheden: _bijzonderhedenController.text.trim(),
      meldenAan: _meldenAanController.text.trim(),
      status: 'isCalling',
      timestamp: nowTime,
    );

    await DatabaseService().saveDei(dei.toMap(), widget.userRole);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _sendIdentificatienummer() async {
    if (widget.existingDei == null) return;
    final String idNummer = _idNummerController.text.trim();

    if (idNummer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vul een identificatienummer in.')),
      );
      return;
    }

    await DatabaseService().updateDeiStatus(
      widget.existingDei!.id,
      widget.userRole,
      'id_sent',
      identificatienummer: idNummer,
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _cancelDei() async {
    if (widget.existingDei == null) return;

    await DatabaseService().cancelDei(widget.existingDei!.id, widget.userRole);

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
