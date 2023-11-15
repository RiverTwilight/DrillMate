class RockRecord {
  String projectId;
  String mainNo;
  String subNo;
  String tsuyaNo;
  String era;
  String origin;
  String lithology;
  String soilType;
  String stratumDescribe;
  int fa;
  int qik;
  double? cohesion;
  double? internalFrictionAngle;
  double? compressibilityCoefficient;
  double? poissonsRatio;
  double? deformationModulus;
  double? pressureDegree;
  double? rockUniaxial;
  int status;
  String remark;

  RockRecord({
    this.projectId = "",
    this.mainNo = "",
    this.subNo = "",
    this.tsuyaNo = "",
    this.era = "",
    this.origin = "",
    this.lithology = "",
    this.soilType = "",
    this.stratumDescribe = "",
    this.fa = 0,
    this.qik = 0,
    this.cohesion,
    this.internalFrictionAngle,
    this.compressibilityCoefficient,
    this.poissonsRatio,
    this.deformationModulus,
    this.pressureDegree,
    this.rockUniaxial,
    this.status = 0,
    this.remark = "",
  });

  // You can add fromJson and toJson methods here if needed for serialization/deserialization
}
