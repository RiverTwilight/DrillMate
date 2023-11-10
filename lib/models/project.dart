import 'dart:math';
import 'package:hgeology_app/services/database_handler.dart';

class Project implements AppDatabaseEntity {
  final String id;
  final String? projectName;
  final String? projectSerialNumber;
  final String? projectType;
  final String? projectSource;
  final String? projectProvince;
  final String? projectCity;
  final String? projectDistrict;
  final String? projectAddress;
  final String? projectCategory;
  final String? projectScale;
  final String? siteType;
  final String? siteCategory;
  final String? surveyGrade;
  final String? constructionUnit;
  final String? projectManagerID;
  final String? uploadUserID;
  final String? enterpriseID;
  final String? longitude;
  final String? latitude;
  final String? projectState;
  final String? startDate;
  final String? completionDate;
  final String? createdOn;
  final String? updatedOn;
  final String? description;
  final String? notes;
  final bool? isDisabled;

  Project({
    required this.id,
    this.projectName,
    this.projectSerialNumber,
    this.projectType,
    this.projectSource,
    this.projectProvince,
    this.projectCity,
    this.projectDistrict,
    this.projectAddress,
    this.projectCategory,
    this.projectScale,
    this.siteType,
    this.siteCategory,
    this.surveyGrade,
    this.constructionUnit,
    this.projectManagerID,
    this.uploadUserID,
    this.enterpriseID,
    this.longitude,
    this.latitude,
    this.projectState,
    this.startDate,
    this.completionDate,
    this.createdOn,
    this.updatedOn,
    this.description,
    this.notes,
    this.isDisabled,
  });

  Map<String, dynamic> toJson() => {
        'Id': id,
        'ProjectName': projectName,
        'ProjectSerialNumber': projectSerialNumber,
        'ProjectType': projectType,
        'ProjectSource': projectSource,
        'ProjectProvince': projectProvince,
        'ProjectCity': projectCity,
        'ProjectDistrict': projectDistrict,
        'ProjectAddress': projectAddress,
        'ProjectCategory': projectCategory,
        'ProjectScale': projectScale,
        'SiteType': siteType,
        'SiteCategory': siteCategory,
        'SurveyGrade': surveyGrade,
        'ConstructionUnit': constructionUnit,
        'ProjectManagerID': projectManagerID,
        'UploadUserID': uploadUserID,
        'EnterpriseID': enterpriseID,
        'Longitude': longitude,
        'Latitude': latitude,
        'ProjectState': projectState,
        'StartDate': startDate,
        'CompletionDate': completionDate,
        'CreatedOn': createdOn,
        'UpdatedOn': updatedOn,
        'Description': description,
        'Notes': notes,
        'IsDisabled': isDisabled,
      };

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['Id'],
        projectName: json['ProjectName'],
        projectSerialNumber: json['ProjectSerialNumber'],
        projectType: json['ProjectType'],
        projectSource: json['ProjectSource'],
        projectProvince: json['ProjectProvince'],
        projectCity: json['ProjectCity'],
        projectDistrict: json['ProjectDistrict'],
        projectAddress: json['ProjectAddress'],
        projectCategory: json['ProjectCategory'],
        projectScale: json['ProjectScale'],
        siteType: json['SiteType'],
        siteCategory: json['SiteCategory'],
        surveyGrade: json['SurveyGrade'],
        constructionUnit: json['ConstructionUnit'],
        projectManagerID: json['ProjectManagerID'],
        uploadUserID: json['UploadUserID'],
        enterpriseID: json['EnterpriseID'],
        longitude: json['Longitude'],
        latitude: json['Latitude'],
        projectState: json['ProjectState'],
        startDate: json['StartDate'],
        completionDate: json['CompletionDate'],
        createdOn: json['CreatedOn'],
        updatedOn: json['UpdatedOn'],
        description: json['Description'],
        notes: json['Notes'],
        isDisabled: json['IsDisabled'] == 1,
      );

  factory Project.mock() {
    return Project(
      id: Random().nextInt(1000).toString(), // Random ID for the mock
      projectName: '示例项目名称${Random().nextInt(100)}', // Example Project Name
      projectSerialNumber: '编号${Random().nextInt(9999)}', // Serial Number
      createdOn: DateTime.now()
          .subtract(Duration(days: Random().nextInt(1000)))
          .toString(), // Random created date
    );
  }
}
