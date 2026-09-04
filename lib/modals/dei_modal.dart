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
  static const Map<String, String> _deiSubtitles = <String, String>{
    '1': 'Toestemming een EOA/stoptonend sein te passeren',
    '2': 'Toestemming tot doorrijden na TRIP',
    '3': 'Verplichting om stil te blijven staan',
    '4': 'Intrekken DEI',
    '5': 'Verplichting om de snelheid te beperken',
    '6': 'Verplichting om te rijden op zicht',
    '7': 'Toestemming om te vertrekken',
    '8': 'Toestemming om een defecte overweg te passeren',
  };

  late String _selectedDeiType;
  late TextEditingController _treinnummerController;
  late TextEditingController _idNummerController;

  // DEI 1
  late TextEditingController _seinnummerController;

  // DEI 2
  late bool _doorrijdenSR;
  late bool _doorrijdenSH;

  // DEI 3
  late bool _huidigeLocatie;
  late bool _maVerwijderen;
  late bool _aanvullendeInstructies;

  // DEI 4
  late TextEditingController _ingetrokkenIdController;

  // DEI 5 & 6
  late TextEditingController _maxSnelheidController;
  late TextEditingController _emplacementVanController;
  late TextEditingController _emplacementTotController;
  late TextEditingController _kilometerVanController;
  late TextEditingController _kilometerTotController;
  late TextEditingController _infraControlerenRedenController;
  late TextEditingController _meldenAanController;

  // DEI 7
  late bool _vertrekkenSR;
  late bool _vertrekkenSH;
  late TextEditingController _passerenEoaSmbController;
  late bool _verbodOverride;

  // DEI 8
  late List<TextEditingController> _overwegenControllers;

  bool _isDuplicating = false;
  bool _isEditingCurrent = false;

  bool get _isCreationMode => widget.existingDei == null || _isDuplicating;
  bool get _isTRDL => widget.userRole == 'LEERLING';

  @override
  void initState() {
    super.initState();
    final DeiModel? dei = widget.existingDei;

    _selectedDeiType = dei?.deiType ?? '1';
    _treinnummerController = TextEditingController(
      text: dei?.treinnummer ?? '',
    );

    // DEI 1
    _seinnummerController = TextEditingController(text: dei?.seinnummer ?? '');

    // DEI 2
    _doorrijdenSR = dei?.doorrijdenSR ?? false;
    _doorrijdenSH = dei?.doorrijdenSH ?? false;

    // DEI 3
    _huidigeLocatie = dei?.huidigeLocatie ?? false;
    _maVerwijderen = dei?.maVerwijderen ?? false;
    _aanvullendeInstructies = dei?.aanvullendeInstructies ?? false;

    // DEI 4
    _ingetrokkenIdController = TextEditingController(
      text: dei?.ingetrokkenIdNummer ?? '',
    );

    // DEI 5 & 6
    _maxSnelheidController = TextEditingController(
      text: dei?.maxSnelheid ?? '40 km/u',
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
    _infraControlerenRedenController = TextEditingController(
      text: dei?.infraControlerenReden ?? '',
    );
    _meldenAanController = TextEditingController(
      text: dei?.meldenAan ?? 'TRDL',
    );

    // DEI 7
    _vertrekkenSR = dei?.vertrekkenSR ?? false;
    _vertrekkenSH = dei?.vertrekkenSH ?? false;
    _passerenEoaSmbController = TextEditingController(
      text: dei?.passerenEoaSmb ?? '',
    );
    _verbodOverride = dei?.verbodOverride ?? false;

    // DEI 8 (9 level crossing fields)
    final List<String> existingOverwegen = dei?.overwegen ?? <String>[];
    _overwegenControllers = List<TextEditingController>.generate(9, (
      int index,
    ) {
      final String initialVal = index < existingOverwegen.length
          ? existingOverwegen[index]
          : '';
      return TextEditingController(text: initialVal);
    });

    final String defaultId = _generateDefaultIdNumber(dei?.treinnummer ?? '');
    _idNummerController = TextEditingController(
      text: dei?.identificatienummer ?? defaultId,
    );
  }

  @override
  void dispose() {
    _treinnummerController.dispose();
    _idNummerController.dispose();
    _seinnummerController.dispose();
    _ingetrokkenIdController.dispose();
    _maxSnelheidController.dispose();
    _emplacementVanController.dispose();
    _emplacementTotController.dispose();
    _kilometerVanController.dispose();
    _kilometerTotController.dispose();
    _infraControlerenRedenController.dispose();
    _meldenAanController.dispose();
    _passerenEoaSmbController.dispose();
    for (final TextEditingController c in _overwegenControllers) {
      c.dispose();
    }
    super.dispose();
  }

  String _generateDefaultIdNumber(String trainNumber) {
    final String nowTime = DateFormat('HHmm').format(DateTime.now());
    if (trainNumber.isEmpty) {
      return nowTime;
    }
    return '$trainNumber$nowTime';
  }

  void _startDuplicatingForNextMcn() {
    setState(() {
      _isDuplicating = true;
      _isEditingCurrent = false;
      _treinnummerController.clear();
      _idNummerController.text = _generateDefaultIdNumber('');
    });
  }

  void _startEditingCurrentDei() {
    setState(() {
      _isEditingCurrent = true;
      _isDuplicating = false;
    });
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    required bool isReadOnly,
    required ColorScheme colorScheme,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onChanged,
  }) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      keyboardType: keyboardType,
      maxLength: maxLength,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      style: TextStyle(
        fontSize: 15,
        fontWeight: isReadOnly ? FontWeight.bold : FontWeight.normal,
        color: colorScheme.onSurface,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        counterText: '',
        prefixIcon: Icon(icon, color: isReadOnly ? colorScheme.primary : null),
        labelStyle: TextStyle(
          color: isReadOnly ? colorScheme.primary : null,
          fontWeight: isReadOnly ? FontWeight.bold : FontWeight.normal,
        ),
        filled: isReadOnly,
        fillColor: isReadOnly
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isReadOnly
                ? colorScheme.primary.withValues(alpha: 0.6)
                : colorScheme.outline,
            width: isReadOnly ? 1.5 : 1.0,
          ),
        ),
      ),
    );
  }

  Widget _buildOptionChip({
    required String label,
    required bool value,
    required bool isReadOnly,
    required ColorScheme colorScheme,
    required ValueChanged<bool> onChanged,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: value ? FontWeight.bold : FontWeight.normal,
          color: value ? colorScheme.onPrimary : colorScheme.onSurface,
        ),
      ),
      selected: value,
      selectedColor: colorScheme.primary,
      disabledColor: value
          ? colorScheme.primary
          : colorScheme.surfaceContainerLow,
      onSelected: isReadOnly
          ? null
          : (bool sel) {
              onChanged(sel);
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool isReadOnly =
        !_isTRDL || (!_isCreationMode && !_isEditingCurrent);

    String headerTitle;
    if (_isDuplicating) {
      headerTitle = 'Gekopieerde DEI';
    } else if (_isEditingCurrent) {
      headerTitle = 'DEI $_selectedDeiType Bewerken';
    } else if (_isCreationMode) {
      headerTitle = 'Nieuwe DEI';
    } else {
      headerTitle =
          'DEI $_selectedDeiType - '
          'Trein ${_treinnummerController.text}';
    }

    final String subtitleText = _deiSubtitles[_selectedDeiType] ?? '';

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
            // Header Title & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    headerTitle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.existingDei != null && !_isDuplicating)
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
                      disabledColor: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerLow,
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
            const SizedBox(height: 12),

            // Official DEI Subtitle Display Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                subtitleText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Common Field: Treinnummer
            _buildCustomTextField(
              controller: _treinnummerController,
              labelText: 'Treinnummer (MCN)',
              hintText: 'bijv. 47705',
              icon: LucideIcons.trainTrack,
              isReadOnly: isReadOnly,
              colorScheme: colorScheme,
              keyboardType: TextInputType.number,
              maxLength: 6,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (String val) {
                if (_isCreationMode) {
                  _idNummerController.text = _generateDefaultIdNumber(val);
                }
              },
            ),
            const SizedBox(height: 12),

            // Dynamic Form Fields based on DEI Type
            ..._buildDynamicFormFields(colorScheme, isReadOnly),

            const SizedBox(height: 16),

            // Identificatienummer section for TRDL when DEI is active
            if (_isTRDL && !_isCreationMode && !_isEditingCurrent) ...<Widget>[
              const Divider(),
              const SizedBox(height: 8),
              _buildCustomTextField(
                controller: _idNummerController,
                labelText: 'Identificatienummer (Trein + Tijd)',
                hintText: 'bijv. 477051250',
                icon: LucideIcons.keyRound,
                isReadOnly: false,
                colorScheme: colorScheme,
                keyboardType: TextInputType.number,
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
            ] else if (_isEditingCurrent && _isTRDL) ...<Widget>[
              ElevatedButton.icon(
                onPressed: _saveEditedDei,
                icon: const Icon(LucideIcons.save),
                label: const Text('Sla wijzigingen op'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
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
                ElevatedButton.icon(
                  onPressed: _startDuplicatingForNextMcn,
                  icon: const Icon(LucideIcons.copyPlus),
                  label: const Text('Afgeven aan volgende MCN'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.secondaryContainer,
                    foregroundColor: colorScheme.onSecondaryContainer,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _startEditingCurrentDei,
                        icon: const Icon(LucideIcons.pencil),
                        label: const Text('DEI Bewerken'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _cancelDei,
                        icon: const Icon(LucideIcons.trash2),
                        label: const Text('DEI Annuleren'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...<Widget>[
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.check),
                  label: const Text('Teruggelezen / Sluiten'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
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

  List<Widget> _buildDynamicFormFields(
    ColorScheme colorScheme,
    bool isReadOnly,
  ) {
    switch (_selectedDeiType) {
      case '1':
        return <Widget>[
          _buildCustomTextField(
            controller: _seinnummerController,
            labelText: 'Seinnummer',
            hintText: 'bijv. Sein 102',
            icon: LucideIcons.trainTrack,
            isReadOnly: isReadOnly,
            colorScheme: colorScheme,
          ),
        ];

      case '2':
        return <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _buildOptionChip(
                label: 'Doorrijden in SR (geen MA)',
                value: _doorrijdenSR,
                isReadOnly: isReadOnly,
                colorScheme: colorScheme,
                onChanged: (bool val) {
                  setState(() {
                    _doorrijdenSR = val;
                  });
                },
              ),
              _buildOptionChip(
                label: 'Doorrijden in SH',
                value: _doorrijdenSH,
                isReadOnly: isReadOnly,
                colorScheme: colorScheme,
                onChanged: (bool val) {
                  setState(() {
                    _doorrijdenSH = val;
                  });
                },
              ),
            ],
          ),
        ];

      case '3':
        return <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _buildOptionChip(
                label: 'Op de huidige locatie',
                value: _huidigeLocatie,
                isReadOnly: isReadOnly,
                colorScheme: colorScheme,
                onChanged: (bool val) {
                  setState(() {
                    _huidigeLocatie = val;
                  });
                },
              ),
              _buildOptionChip(
                label: 'Beschikbare MA verwijderen',
                value: _maVerwijderen,
                isReadOnly: isReadOnly,
                colorScheme: colorScheme,
                onChanged: (bool val) {
                  setState(() {
                    _maVerwijderen = val;
                  });
                },
              ),
              _buildOptionChip(
                label: 'Aanvullende instructies',
                value: _aanvullendeInstructies,
                isReadOnly: isReadOnly,
                colorScheme: colorScheme,
                onChanged: (bool val) {
                  setState(() {
                    _aanvullendeInstructies = val;
                  });
                },
              ),
            ],
          ),
        ];

      case '4':
        return <Widget>[
          _buildCustomTextField(
            controller: _ingetrokkenIdController,
            labelText: 'Ingetrokken Identificatienummer',
            hintText: 'bijv. 30641250',
            icon: LucideIcons.fileX,
            isReadOnly: isReadOnly,
            colorScheme: colorScheme,
            keyboardType: TextInputType.number,
          ),
        ];

      case '5':
      case '6':
        return <Widget>[
          _buildCustomTextField(
            controller: _maxSnelheidController,
            labelText: 'De maximumsnelheid beperken tot',
            hintText: '40 km/u',
            icon: LucideIcons.gauge,
            isReadOnly: isReadOnly,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildCustomTextField(
                  controller: _emplacementVanController,
                  labelText: 'Van/Op Emplacement',
                  hintText: 'bijv. Amr / Alkmaar',
                  icon: LucideIcons.mapPin,
                  isReadOnly: isReadOnly,
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCustomTextField(
                  controller: _emplacementTotController,
                  labelText: 'Tot Emplacement',
                  hintText: 'bijv. Utg / Uitgeest',
                  icon: LucideIcons.mapPinOff,
                  isReadOnly: isReadOnly,
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _buildCustomTextField(
                  controller: _kilometerVanController,
                  labelText: 'Van/Bij Kilometer',
                  hintText: 'bijv. 43.0',
                  icon: LucideIcons.ruler,
                  isReadOnly: isReadOnly,
                  colorScheme: colorScheme,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCustomTextField(
                  controller: _kilometerTotController,
                  labelText: 'Tot Kilometer',
                  hintText: 'bijv. 43.8',
                  icon: LucideIcons.ruler,
                  isReadOnly: isReadOnly,
                  colorScheme: colorScheme,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCustomTextField(
            controller: _infraControlerenRedenController,
            labelText: 'Controleren van de infrastructuur om de reden(en)',
            hintText: 'bijv. Spoorlopers / Werkzaamheden',
            icon: LucideIcons.triangleAlert,
            isReadOnly: isReadOnly,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          _buildCustomTextField(
            controller: _meldenAanController,
            labelText: 'Meld bevindingen aan',
            hintText: 'bijv. TRDL',
            icon: LucideIcons.userCheck,
            isReadOnly: isReadOnly,
            colorScheme: colorScheme,
          ),
        ];

      case '7':
        return <Widget>[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              _buildOptionChip(
                label: 'Vertrekken in SR',
                value: _vertrekkenSR,
                isReadOnly: isReadOnly,
                colorScheme: colorScheme,
                onChanged: (bool val) {
                  setState(() {
                    _vertrekkenSR = val;
                  });
                },
              ),
              _buildOptionChip(
                label: 'Vertrekken in SH',
                value: _vertrekkenSH,
                isReadOnly: isReadOnly,
                colorScheme: colorScheme,
                onChanged: (bool val) {
                  setState(() {
                    _vertrekkenSH = val;
                  });
                },
              ),
              _buildOptionChip(
                label: 'Verboden override te gebruiken',
                value: _verbodOverride,
                isReadOnly: isReadOnly,
                colorScheme: colorScheme,
                onChanged: (bool val) {
                  setState(() {
                    _verbodOverride = val;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildCustomTextField(
            controller: _passerenEoaSmbController,
            labelText: 'Toestemming om EOA/SMB te passeren',
            hintText: 'bijv. EOA 12',
            icon: LucideIcons.shieldAlert,
            isReadOnly: isReadOnly,
            colorScheme: colorScheme,
          ),
        ];

      case '8':
        return <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: _buildCustomTextField(
                  controller: _emplacementVanController,
                  labelText: 'Van/Op Emplacement',
                  hintText: 'bijv. Amr / Alkmaar',
                  icon: LucideIcons.mapPin,
                  isReadOnly: isReadOnly,
                  colorScheme: colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCustomTextField(
                  controller: _emplacementTotController,
                  labelText: 'Tot Emplacement',
                  hintText: 'bijv. Utg / Uitgeest',
                  icon: LucideIcons.mapPinOff,
                  isReadOnly: isReadOnly,
                  colorScheme: colorScheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Voor de overweg(en):',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Column(
            children: List<Widget>.generate(3, (int rowIndex) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: List<Widget>.generate(3, (int colIndex) {
                    final int fieldIndex = rowIndex * 3 + colIndex;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: colIndex < 2 ? 8 : 0),
                        child: _buildCustomTextField(
                          controller: _overwegenControllers[fieldIndex],
                          labelText: 'Overweg ${fieldIndex + 1}',
                          hintText: 'km 43.${fieldIndex + 1}',
                          icon: LucideIcons.mapPin,
                          isReadOnly: isReadOnly,
                          colorScheme: colorScheme,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ];

      default:
        return <Widget>[];
    }
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

    final DeiModel dei = _constructDeiModelFromInput(deiId, nowTime, 'sent');

    await DatabaseService().saveDei(dei.toMap(), widget.userRole);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _saveEditedDei() async {
    if (widget.existingDei == null) return;
    final String trein = _treinnummerController.text.trim();
    if (trein.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vul a.u.b. een treinnummer in.')),
      );
      return;
    }

    final DeiModel updatedDei = _constructDeiModelFromInput(
      widget.existingDei!.id,
      widget.existingDei!.timestamp,
      widget.existingDei!.status,
    );

    await DatabaseService().saveDei(updatedDei.toMap(), widget.userRole);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  DeiModel _constructDeiModelFromInput(
    String id,
    String timestamp,
    String status,
  ) {
    final List<String> overwegenVals = _overwegenControllers
        .map((TextEditingController c) => c.text.trim())
        .where((String text) => text.isNotEmpty)
        .toList();

    return DeiModel(
      id: id,
      deiType: _selectedDeiType,
      treinnummer: _treinnummerController.text.trim(),
      status: status,
      timestamp: timestamp,
      identificatienummer: _idNummerController.text.trim().isNotEmpty
          ? _idNummerController.text.trim()
          : null,
      seinnummer: _seinnummerController.text.trim().isNotEmpty
          ? _seinnummerController.text.trim()
          : null,
      doorrijdenSR: _doorrijdenSR,
      doorrijdenSH: _doorrijdenSH,
      huidigeLocatie: _huidigeLocatie,
      maVerwijderen: _maVerwijderen,
      aanvullendeInstructies: _aanvullendeInstructies,
      ingetrokkenIdNummer: _ingetrokkenIdController.text.trim().isNotEmpty
          ? _ingetrokkenIdController.text.trim()
          : null,
      maxSnelheid: _maxSnelheidController.text.trim().isNotEmpty
          ? _maxSnelheidController.text.trim()
          : null,
      emplacementVan: _emplacementVanController.text.trim().isNotEmpty
          ? _emplacementVanController.text.trim()
          : null,
      emplacementTot: _emplacementTotController.text.trim().isNotEmpty
          ? _emplacementTotController.text.trim()
          : null,
      kilometerVan: _kilometerVanController.text.trim().isNotEmpty
          ? _kilometerVanController.text.trim()
          : null,
      kilometerTot: _kilometerTotController.text.trim().isNotEmpty
          ? _kilometerTotController.text.trim()
          : null,
      infraControlerenReden:
          _infraControlerenRedenController.text.trim().isNotEmpty
          ? _infraControlerenRedenController.text.trim()
          : null,
      meldenAan: _meldenAanController.text.trim().isNotEmpty
          ? _meldenAanController.text.trim()
          : null,
      vertrekkenSR: _vertrekkenSR,
      vertrekkenSH: _vertrekkenSH,
      passerenEoaSmb: _passerenEoaSmbController.text.trim().isNotEmpty
          ? _passerenEoaSmbController.text.trim()
          : null,
      verbodOverride: _verbodOverride,
      overwegen: overwegenVals.isNotEmpty ? overwegenVals : null,
    );
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
