class DeiModel {
  const DeiModel({
    required this.id,
    required this.deiType,
    required this.treinnummer,
    required this.status,
    required this.timestamp,
    this.identificatienummer,
    this.initiator = 'LEERLING',
    this.seinnummer,
    this.doorrijdenSR,
    this.doorrijdenSH,
    this.huidigeLocatie,
    this.maVerwijderen,
    this.aanvullendeInstructies,
    this.ingetrokkenIdNummer,
    this.maxSnelheid,
    this.emplacementVan,
    this.emplacementTot,
    this.kilometerVan,
    this.kilometerTot,
    this.infraControlerenReden,
    this.meldenAan,
    this.vertrekkenSR,
    this.vertrekkenSH,
    this.passerenEoaSmb,
    this.verbodOverride,
    this.overwegen,
  });

  factory DeiModel.fromMap(String id, Map<String, dynamic> map) {
    return DeiModel(
      id: id,
      deiType: (map['deiType'] as String?) ?? '1',
      treinnummer: (map['treinnummer'] as String?) ?? '',
      status: (map['status'] as String?) ?? 'sent',
      timestamp: (map['timestamp'] as String?) ?? '',
      identificatienummer: map['identificatienummer'] as String?,
      initiator: (map['initiator'] as String?) ?? 'LEERLING',
      seinnummer: map['seinnummer'] as String?,
      doorrijdenSR: map['doorrijdenSR'] as bool?,
      doorrijdenSH: map['doorrijdenSH'] as bool?,
      huidigeLocatie: map['huidigeLocatie'] as bool?,
      maVerwijderen: map['maVerwijderen'] as bool?,
      aanvullendeInstructies: map['aanvullendeInstructies'] as bool?,
      ingetrokkenIdNummer: map['ingetrokkenIdNummer'] as String?,
      maxSnelheid: map['maxSnelheid'] as String?,
      emplacementVan: map['emplacementVan'] as String?,
      emplacementTot: map['emplacementTot'] as String?,
      kilometerVan: map['kilometerVan'] as String?,
      kilometerTot: map['kilometerTot'] as String?,
      infraControlerenReden: map['infraControlerenReden'] as String?,
      meldenAan: map['meldenAan'] as String?,
      vertrekkenSR: map['vertrekkenSR'] as bool?,
      vertrekkenSH: map['vertrekkenSH'] as bool?,
      passerenEoaSmb: map['passerenEoaSmb'] as String?,
      verbodOverride: map['verbodOverride'] as bool?,
      overwegen: (map['overwegen'] as List<dynamic>?)
          ?.map((dynamic e) => e.toString())
          .toList(),
    );
  }

  final String id;
  final String deiType;
  final String treinnummer;
  final String status;
  final String timestamp;
  final String? identificatienummer;
  final String initiator;

  // DEI 1
  final String? seinnummer;

  // DEI 2
  final bool? doorrijdenSR;
  final bool? doorrijdenSH;

  // DEI 3
  final bool? huidigeLocatie;
  final bool? maVerwijderen;
  final bool? aanvullendeInstructies;

  // DEI 4
  final String? ingetrokkenIdNummer;

  // DEI 5 & 6
  final String? maxSnelheid;
  final String? emplacementVan;
  final String? emplacementTot;
  final String? kilometerVan;
  final String? kilometerTot;
  final String? infraControlerenReden;
  final String? meldenAan;

  // DEI 7
  final bool? vertrekkenSR;
  final bool? vertrekkenSH;
  final String? passerenEoaSmb;
  final bool? verbodOverride;

  // DEI 8
  final List<String>? overwegen;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{
      'id': id,
      'deiType': deiType,
      'treinnummer': treinnummer,
      'status': status,
      'timestamp': timestamp,
      'initiator': initiator,
    };

    if (identificatienummer != null) {
      map['identificatienummer'] = identificatienummer;
    }
    if (seinnummer != null) map['seinnummer'] = seinnummer;
    if (doorrijdenSR != null) map['doorrijdenSR'] = doorrijdenSR;
    if (doorrijdenSH != null) map['doorrijdenSH'] = doorrijdenSH;
    if (huidigeLocatie != null) map['huidigeLocatie'] = huidigeLocatie;
    if (maVerwijderen != null) map['maVerwijderen'] = maVerwijderen;
    if (aanvullendeInstructies != null) {
      map['aanvullendeInstructies'] = aanvullendeInstructies;
    }
    if (ingetrokkenIdNummer != null) {
      map['ingetrokkenIdNummer'] = ingetrokkenIdNummer;
    }
    if (maxSnelheid != null) map['maxSnelheid'] = maxSnelheid;
    if (emplacementVan != null) map['emplacementVan'] = emplacementVan;
    if (emplacementTot != null) map['emplacementTot'] = emplacementTot;
    if (kilometerVan != null) map['kilometerVan'] = kilometerVan;
    if (kilometerTot != null) map['kilometerTot'] = kilometerTot;
    if (infraControlerenReden != null) {
      map['infraControlerenReden'] = infraControlerenReden;
    }
    if (meldenAan != null) map['meldenAan'] = meldenAan;
    if (vertrekkenSR != null) map['vertrekkenSR'] = vertrekkenSR;
    if (vertrekkenSH != null) map['vertrekkenSH'] = vertrekkenSH;
    if (passerenEoaSmb != null) map['passerenEoaSmb'] = passerenEoaSmb;
    if (verbodOverride != null) map['verbodOverride'] = verbodOverride;
    if (overwegen != null && overwegen!.isNotEmpty) {
      map['overwegen'] = overwegen;
    }

    return map;
  }

  DeiModel copyWith({
    String? id,
    String? deiType,
    String? treinnummer,
    String? status,
    String? timestamp,
    String? identificatienummer,
    String? initiator,
    String? seinnummer,
    bool? doorrijdenSR,
    bool? doorrijdenSH,
    bool? huidigeLocatie,
    bool? maVerwijderen,
    bool? aanvullendeInstructies,
    String? ingetrokkenIdNummer,
    String? maxSnelheid,
    String? emplacementVan,
    String? emplacementTot,
    String? kilometerVan,
    String? kilometerTot,
    String? infraControlerenReden,
    String? meldenAan,
    bool? vertrekkenSR,
    bool? vertrekkenSH,
    String? passerenEoaSmb,
    bool? verbodOverride,
    List<String>? overwegen,
  }) {
    return DeiModel(
      id: id ?? this.id,
      deiType: deiType ?? this.deiType,
      treinnummer: treinnummer ?? this.treinnummer,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      identificatienummer: identificatienummer ?? this.identificatienummer,
      initiator: initiator ?? this.initiator,
      seinnummer: seinnummer ?? this.seinnummer,
      doorrijdenSR: doorrijdenSR ?? this.doorrijdenSR,
      doorrijdenSH: doorrijdenSH ?? this.doorrijdenSH,
      huidigeLocatie: huidigeLocatie ?? this.huidigeLocatie,
      maVerwijderen: maVerwijderen ?? this.maVerwijderen,
      aanvullendeInstructies:
          aanvullendeInstructies ?? this.aanvullendeInstructies,
      ingetrokkenIdNummer: ingetrokkenIdNummer ?? this.ingetrokkenIdNummer,
      maxSnelheid: maxSnelheid ?? this.maxSnelheid,
      emplacementVan: emplacementVan ?? this.emplacementVan,
      emplacementTot: emplacementTot ?? this.emplacementTot,
      kilometerVan: kilometerVan ?? this.kilometerVan,
      kilometerTot: kilometerTot ?? this.kilometerTot,
      infraControlerenReden:
          infraControlerenReden ?? this.infraControlerenReden,
      meldenAan: meldenAan ?? this.meldenAan,
      vertrekkenSR: vertrekkenSR ?? this.vertrekkenSR,
      vertrekkenSH: vertrekkenSH ?? this.vertrekkenSH,
      passerenEoaSmb: passerenEoaSmb ?? this.passerenEoaSmb,
      verbodOverride: verbodOverride ?? this.verbodOverride,
      overwegen: overwegen ?? this.overwegen,
    );
  }
}
