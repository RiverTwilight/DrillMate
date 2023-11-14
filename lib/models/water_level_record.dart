class WaterLevelRecord {
  final String projectId;
  final String holeId;
  final String type;
  final int? waterLevelLayerNum;
  final double? seeWaterlevel;
  final DateTime? seeTime;
  final double? stableWaterlevel;
  final DateTime? stableTime;
  final String recordNo;
  final double? moveDistance;
  final String recorderId;
  final double? baiduX;
  final double? baiduY;
  final DateTime recordTime;
  final String satelliteRecord;
  final String? groupId;
  final double? gcj02X;
  final double? gcj02Y;

  WaterLevelRecord({
    required this.projectId,
    required this.holeId,
    required this.type,
    this.waterLevelLayerNum,
    this.seeWaterlevel,
    this.seeTime,
    this.stableWaterlevel,
    this.stableTime,
    required this.recordNo,
    this.moveDistance,
    required this.recorderId,
    this.baiduX,
    this.baiduY,
    required this.recordTime,
    required this.satelliteRecord,
    this.groupId,
    this.gcj02X,
    this.gcj02Y,
  });

  factory WaterLevelRecord.fromJson(Map<String, dynamic> json) {
    return WaterLevelRecord(
      projectId: json['ProjectID'],
      holeId: json['HoleID'],
      type: json['Type'],
      waterLevelLayerNum: json['WaterLevelLayerNum'],
      seeWaterlevel: json['SeeWaterlevel'],
      seeTime: json['SeeTime'] != null ? DateTime.parse(json['SeeTime']) : null,
      stableWaterlevel: json['StableWaterlevel'],
      stableTime: json['StableTime'] != null
          ? DateTime.parse(json['StableTime'])
          : null,
      recordNo: json['RecordNo'],
      moveDistance: json['MoveDistance'],
      recorderId: json['RecorderID'],
      baiduX: json['BaiduX'],
      baiduY: json['BaiduY'],
      recordTime: DateTime.parse(json['RecordTime']),
      satelliteRecord: json['SatelliteRecord'],
      groupId: json['GroupID'],
      gcj02X: json['GCJ02X'],
      gcj02Y: json['GCJ02Y'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProjectID': projectId,
      'HoleID': holeId,
      'Type': type,
      'WaterLevelLayerNum': waterLevelLayerNum,
      'SeeWaterlevel': seeWaterlevel,
      'SeeTime': seeTime?.toIso8601String(),
      'StableWaterlevel': stableWaterlevel,
      'StableTime': stableTime?.toIso8601String(),
      'RecordNo': recordNo,
      'MoveDistance': moveDistance,
      'RecorderID': recorderId,
      'BaiduX': baiduX,
      'BaiduY': baiduY,
      'RecordTime': recordTime.toIso8601String(),
      'SatelliteRecord': satelliteRecord,
      'GroupID': groupId,
      'GCJ02X': gcj02X,
      'GCJ02Y': gcj02Y,
    };
  }
}
