class BackRulerRecord {
  final Guid projectId;
  final Guid holeId;
  final double? depthStart;
  final double? depthEnd;
  final String protectwallMethod;
  final String drillEnterMethod;
  final String drillingSize;
  final String recordNo;
  final double? moveDistance;
  final Guid recorderId;
  final double? baiduX;
  final double? baiduY;
  final DateTime recordTime;
  final double? tubingDepth;
  final String satelliteRecord;
  final Guid? groupId;
  final double? gcj02X;
  final double? gcj02Y;

  BackRulerRecord({
    required this.projectId,
    required this.holeId,
    this.depthStart,
    this.depthEnd,
    required this.protectwallMethod,
    required this.drillEnterMethod,
    required this.drillingSize,
    required this.recordNo,
    this.moveDistance,
    required this.recorderId,
    this.baiduX,
    this.baiduY,
    required this.recordTime,
    this.tubingDepth,
    required this.satelliteRecord,
    this.groupId,
    this.gcj02X,
    this.gcj02Y,
  });

  factory BackRulerRecord.fromJson(Map<String, dynamic> json) {
    return BackRulerRecord(
      projectId: Guid.parse(json['projectId']),
      holeId: Guid.parse(json['holeId']),
      depthStart: json['depthStart']?.toDouble(),
      depthEnd: json['depthEnd']?.toDouble(),
      protectwallMethod: json['protectwallMethod'],
      drillEnterMethod: json['drillEnterMethod'],
      drillingSize: json['drillingSize'],
      recordNo: json['recordNo'],
      moveDistance: json['moveDistance']?.toDouble(),
      recorderId: Guid.parse(json['recorderId']),
      baiduX: json['baiduX']?.toDouble(),
      baiduY: json['baiduY']?.toDouble(),
      recordTime: DateTime.parse(json['recordTime']),
      tubingDepth: json['tubingDepth']?.toDouble(),
      satelliteRecord: json['satelliteRecord'],
      groupId: json['groupId'] != null ? Guid.parse(json['groupId']) : null,
      gcj02X: json['gcj02X']?.toDouble(),
      gcj02Y: json['gcj02Y']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId.toString(),
      'holeId': holeId.toString(),
      'depthStart': depthStart,
      'depthEnd': depthEnd,
      'protectwallMethod': protectwallMethod,
      'drillEnterMethod': drillEnterMethod,
      'drillingSize': drillingSize,
      'recordNo': recordNo,
      'moveDistance': moveDistance,
      'recorderId': recorderId.toString(),
      'baiduX': baiduX,
      'baiduY': baiduY,
      'recordTime': recordTime.toIso8601String(),
      'tubingDepth': tubingDepth,
      'satelliteRecord': satelliteRecord,
      'groupId': groupId?.toString(),
      'gcj02X': gcj02X,
      'gcj02Y': gcj02Y,
    };
  }

  BackRulerRecord copyWith({
    Guid? projectId,
    Guid? holeId,
    double? depthStart,
    double? depthEnd,
    String? protectwallMethod,
    String? drillEnterMethod,
    String? drillingSize,
    String? recordNo,
    double? moveDistance,
    Guid? recorderId,
    double? baiduX,
    double? baiduY,
    DateTime? recordTime,
    double? tubingDepth,
    String? satelliteRecord,
    Guid? groupId,
    double? gcj02X,
    double? gcj02Y,
  }) {
    return BackRulerRecord(
      projectId: projectId ?? this.projectId,
      holeId: holeId ?? this.holeId,
      depthStart: depthStart ?? this.depthStart,
      depthEnd: depthEnd ?? this.depthEnd,
      protectwallMethod: protectwallMethod ?? this.protectwallMethod,
      drillEnterMethod: drillEnterMethod ?? this.drillEnterMethod,
      drillingSize: drillingSize ?? this.drillingSize,
      recordNo: recordNo ?? this.recordNo,
      moveDistance: moveDistance ?? this.moveDistance,
      recorderId: recorderId ?? this.recorderId,
      baiduX: baiduX ?? this.baiduX,
      baiduY: baiduY ?? this.baiduY,
      recordTime: recordTime ?? this.recordTime,
      tubingDepth: tubingDepth ?? this.tubingDepth,
      satelliteRecord: satelliteRecord ?? this.satelliteRecord,
      groupId: groupId ?? this.groupId,
      gcj02X: gcj02X ?? this.gcj02X,
      gcj02Y: gcj02Y ?? this.gcj02Y,
    );
  }
}

class Guid {
  final String value;

  Guid._(this.value);

  static Guid parse(String value) {
    // Add validation or parsing logic if necessary
    return Guid._(value);
  }

  @override
  String toString() {
    return value;
  }
}
