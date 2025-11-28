class MoveDetailModel {
  final int? power;
  final String moveType;
  final String damageClass;

  MoveDetailModel({
    required this.power,
    required this.moveType,
    required this.damageClass,
  });

  String get formattedDamageClass {
    return damageClass[0].toUpperCase() + damageClass.substring(1);
  }
}
