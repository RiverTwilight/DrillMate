import 'dart:ffi';
import 'dart:math';

import 'package:hgeology_app/services/database_handler.dart';

class Hole implements AppDatabaseEntity {
  @override
  final String id;
  final String projectId;
  final String? holeNo;
  final String? recorderId;
  final String? holeType;
  final String? status;
  final String? state;
  final String? holePointType;
  final double? height;
  final double? depth;
  final double? dia;
  final double? sWaterlevel;
  final double? eWaterlevel;
  final String? longitude;
  final String? latitude;
  final String? baiduX;
  final String? baiduY;
  final double? coordinateX;
  final double? coordinateY;
  final DateTime recordTime;
  final String? technicalRequirements;
  final bool isFinished;
  final double? designDepth;
  final double? mileage;
  final double? structuralFloorElevation;
  final DateTime? openHoleDate;
  final DateTime? endHoleDate;
  final DateTime? closeHoleDate;
  final bool isCheck;
  final String? engineerId;
  final String? handleOpinions;
  final double? designX;
  final double? designY;
  final bool isCombine;
  final String? groupId;
  final double? gcj02X;
  final double? gcj02Y;
  final DateTime? lastRecordDate;
  final DateTime? lastExportFieldDate;
  final DateTime? lastUpdateBusinessDate;
  final DateTime? lastExportSurveyDate;
  final DateTime? lastUseStandaryLayerDate;
  final bool? isUploadRegulatory;
  final double? loftingX;
  final double? loftingY;
  final double? loftingElevation;
  final double? retestX;
  final double? retestY;
  final double? retestElevation;
  final double? designElevation;
  final double? offsetDistance;
  final String? machineNo;
  final double? endHoleDepth;
  final String? openHoleDateString;
  final String? endHoleDateString;
  final String guid;
  final int createdBy;
  final String? createdByName;
  final String? createdOnString;
  final int? updatedBy;
  final String? updatedByName;
  final DateTime createdOn;
  final DateTime? updatedOn;
  final String? updatedOnString;
  final String? notes;
  final int totalCount;
  final bool? isDisabled;
  final DateTime? disabledTime;
  final String? disabledTimeString;
  final bool? isDel;
  final DateTime? deleteTime;
  final String? deleteTimeString;
  final int? disabledBy;
  final int? deleteBy;

  Hole({
    required this.projectId,
    this.holeNo,
    this.recorderId,
    this.holeType,
    this.status,
    this.state,
    this.holePointType,
    this.height,
    this.depth,
    this.dia,
    this.sWaterlevel,
    this.eWaterlevel,
    this.longitude,
    this.latitude,
    this.baiduX,
    this.baiduY,
    this.coordinateX,
    this.coordinateY,
    required this.recordTime,
    this.technicalRequirements,
    required this.isFinished,
    this.designDepth,
    this.mileage,
    this.structuralFloorElevation,
    this.openHoleDate,
    this.endHoleDate,
    this.closeHoleDate,
    required this.isCheck,
    this.engineerId,
    this.handleOpinions,
    this.designX,
    this.designY,
    required this.isCombine,
    this.groupId,
    this.gcj02X,
    this.gcj02Y,
    this.lastRecordDate,
    this.lastExportFieldDate,
    this.lastUpdateBusinessDate,
    this.lastExportSurveyDate,
    this.lastUseStandaryLayerDate,
    this.isUploadRegulatory,
    this.loftingX,
    this.loftingY,
    this.loftingElevation,
    this.retestX,
    this.retestY,
    this.retestElevation,
    this.designElevation,
    this.offsetDistance,
    this.machineNo,
    this.endHoleDepth,
    this.openHoleDateString,
    this.endHoleDateString,
    required this.id,
    required this.guid,
    required this.createdBy,
    this.createdByName,
    this.createdOnString,
    this.updatedBy,
    this.updatedByName,
    required this.createdOn,
    this.updatedOn,
    this.updatedOnString,
    this.notes,
    required this.totalCount,
    this.isDisabled,
    this.disabledTime,
    this.disabledTimeString,
    this.isDel,
    this.deleteTime,
    this.deleteTimeString,
    this.disabledBy,
    this.deleteBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'ProjectID': projectId,
      'HoleNo': holeNo,
      'RecorderID': recorderId,
      'HoleType': holeType,
      'Status': status,
      'State': state,
      // ... add all other fields ...
      'RecordTime': recordTime.toIso8601String(),
      'IsFinished': isFinished,
      'IsCheck': isCheck,
      'IsCombine': isCombine,
      'Id': id,
      'Guid': guid,
      'CreatedBy': createdBy,
      'CreatedOn': createdOn.toIso8601String(),
      'TotalCount': totalCount,
      // ... add all other fields ...
    };
  }

  factory Hole.fromJson(Map<String, dynamic> json) {
    return Hole(
      projectId: json['ProjectID'],
      holeNo: json['HoleNo'],
      recorderId: json['RecorderID'],
      holeType: json['HoleType'],
      status: json['Status'],
      state: json['State'],
      offsetDistance: json['offsetDistance'],
      // ... add all other fields ...
      recordTime: DateTime.parse(json['RecordTime']),
      isFinished: json['IsFinished'],
      isCheck: json['IsCheck'],
      isCombine: json['IsCombine'],
      id: json['Id'],
      guid: json['Guid'],
      createdBy: json['CreatedBy'],
      createdOn: DateTime.parse(json['CreatedOn']),
      totalCount: json['TotalCount'],
      // ... add all other fields ...
    );
  }

  factory Hole.mock() {
    return Hole(
      projectId: '00000000-0000-0000-0000-000000000000',
      holeNo: 'Hole${Random().nextInt(100)}',
      recorderId: 'Recorder${Random().nextInt(100)}',
      holeType: '静探 ${Random().nextInt(5)}',
      status: 'Status${Random().nextInt(5)}',
      state: 'State${Random().nextInt(5)}',
      offsetDistance: Random().nextDouble(),
      // ... provide mock values for other fields ...
      recordTime: DateTime.now(),
      isFinished: Random().nextBool(),
      isCheck: Random().nextBool(),
      isCombine: Random().nextBool(),
      id: Random().nextInt(1000).toString(),
      guid: '00000000-0000-0000-0000-000000000000',
      createdBy: Random().nextInt(100),
      createdOn: DateTime.now(),
      totalCount: Random().nextInt(100),
    );
  }

  Hole copyWith({
    String? projectId,
    String? holeNo,
    String? holeType,
    // ... other fields ...
    DateTime? recordTime,
    bool? isFinished,
    bool? isCheck,
    bool? isCombine,
    Double? offsetDistance,
    String? id,
    String? guid,
    int? createdBy,
    DateTime? createdOn,
    int? totalCount,
    // ... other fields ...
  }) {
    return Hole(
      projectId: projectId ?? this.projectId,
      holeNo: holeNo ?? this.holeNo,
      holeType: holeType ?? this.holeType,
      recordTime: recordTime ?? this.recordTime,
      isFinished: isFinished ?? this.isFinished,
      isCheck: isCheck ?? this.isCheck,
      isCombine: isCombine ?? this.isCombine,
      id: id ?? this.id,
      guid: guid ?? this.guid,
      createdBy: createdBy ?? this.createdBy,
      createdOn: createdOn ?? this.createdOn,
      totalCount: totalCount ?? this.totalCount,
      // ... other field assignments ...
    );
  }
}
