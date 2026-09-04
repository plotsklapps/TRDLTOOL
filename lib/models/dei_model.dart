class DeiModel {
  const DeiModel({
    required this.id,
    required this.deiType,
    required this.treinnummer,
    required this.maxSnelheid,
    required this.emplacementVan,
    required this.emplacementTot,
    required this.kilometerVan,
    required this.kilometerTot,
    required this.bijzonderheden,
    required this.meldenAan,
    required this.status,
    required this.timestamp,
    this.identificatienummer,
    this.initiator = 'LEERLING',
  });

  factory DeiModel.fromMap(String id, Map<String, dynamic> map) {
    return DeiModel(
      id: id,
      deiType: (map['deiType'] as String?) ?? '6',
      treinnummer: (map['treinnummer'] as String?) ?? '',
      maxSnelheid: (map['maxSnelheid'] as String?) ?? '40 km/h',
      emplacementVan: (map['emplacementVan'] as String?) ?? '',
      emplacementTot: (map['emplacementTot'] as String?) ?? '',
      kilometerVan: (map['kilometerVan'] as String?) ?? '',
      kilometerTot: (map['kilometerTot'] as String?) ?? '',
      bijzonderheden: (map['bijzonderheden'] as String?) ?? '',
      meldenAan: (map['meldenAan'] as String?) ?? 'TRDL',
      status: (map['status'] as String?) ?? 'isCalling',
      timestamp: (map['timestamp'] as String?) ?? '',
      identificatienummer: map['identificatienummer'] as String?,
      initiator: (map['initiator'] as String?) ?? 'LEERLING',
    );
  }

  final String id;
  final String deiType;
  final String treinnummer;
  final String maxSnelheid;
  final String emplacementVan;
  final String emplacementTot;
  final String kilometerVan;
  final String kilometerTot;
  final String bijzonderheden;
  final String meldenAan;
  final String status;
  final String timestamp;
  final String? identificatienummer;
  final String initiator;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'deiType': deiType,
      'treinnummer': treinnummer,
      'maxSnelheid': maxSnelheid,
      'emplacementVan': emplacementVan,
      'emplacementTot': emplacementTot,
      'kilometerVan': kilometerVan,
      'kilometerTot': kilometerTot,
      'bijzonderheden': bijzonderheden,
      'meldenAan': meldenAan,
      'status': status,
      'timestamp': timestamp,
      'identificatienummer': identificatienummer,
      'initiator': initiator,
    };
  }

  DeiModel copyWith({
    String? id,
    String? deiType,
    String? treinnummer,
    String? maxSnelheid,
    String? emplacementVan,
    String? emplacementTot,
    String? kilometerVan,
    String? kilometerTot,
    String? bijzonderheden,
    String? meldenAan,
    String? status,
    String? timestamp,
    String? identificatienummer,
    String? initiator,
  }) {
    return DeiModel(
      id: id ?? this.id,
      deiType: deiType ?? this.deiType,
      treinnummer: treinnummer ?? this.treinnummer,
      maxSnelheid: maxSnelheid ?? this.maxSnelheid,
      emplacementVan: emplacementVan ?? this.emplacementVan,
      emplacementTot: emplacementTot ?? this.emplacementTot,
      kilometerVan: kilometerVan ?? this.kilometerVan,
      kilometerTot: kilometerTot ?? this.kilometerTot,
      bijzonderheden: bijzonderheden ?? this.bijzonderheden,
      meldenAan: meldenAan ?? this.meldenAan,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      identificatienummer: identificatienummer ?? this.identificatienummer,
      initiator: initiator ?? this.initiator,
    );
  }
}
