class PokemonAbility {
  final String name;

  PokemonAbility({required this.name});

  String get formattedName =>
      name.replaceAll('-', ' ')[0].toUpperCase() +
      name.replaceAll('-', ' ').substring(1);
}

class TypeEffectivenessModel {
  final List<String> doubleDamageFrom;
  final List<String> halfDamageFrom;
  final List<String> noDamageFrom;

  TypeEffectivenessModel({
    required this.doubleDamageFrom,
    required this.halfDamageFrom,
    required this.noDamageFrom,
  });

  factory TypeEffectivenessModel.combine(
    List<TypeEffectivenessModel> typeData,
  ) {
    if (typeData.isEmpty) {
      return TypeEffectivenessModel(
        doubleDamageFrom: [],
        halfDamageFrom: [],
        noDamageFrom: [],
      );
    }

    Map<String, double> finalEffectiveness = {};

    for (var data in typeData) {
      for (var type in data.doubleDamageFrom) {
        finalEffectiveness[type] = (finalEffectiveness[type] ?? 1.0) * 2.0;
      }
      for (var type in data.halfDamageFrom) {
        finalEffectiveness[type] = (finalEffectiveness[type] ?? 1.0) * 0.5;
      }
      for (var type in data.noDamageFrom) {
        finalEffectiveness[type] = 0.0;
      }
    }

    List<String> combinedWeaknesses = [];
    List<String> combinedResistances = [];
    List<String> combinedImmunities = [];

    finalEffectiveness.forEach((type, multiplier) {
      if (multiplier >= 2.0) {
        combinedWeaknesses.add(type);
      } else if (multiplier == 0.0) {
        combinedImmunities.add(type);
      } else if (multiplier <= 0.5 && multiplier > 0.0) {
        combinedResistances.add(type);
      }
    });

    return TypeEffectivenessModel(
      doubleDamageFrom: combinedWeaknesses,
      halfDamageFrom: combinedResistances,
      noDamageFrom: combinedImmunities,
    );
  }
}
