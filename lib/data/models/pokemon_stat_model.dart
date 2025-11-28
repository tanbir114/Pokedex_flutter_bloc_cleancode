class PokemonStat {
  final String name;
  final int baseStat;

  PokemonStat({required this.name, required this.baseStat});

  String get formattedName {
    if (name == 'special-attack') return 'Sp. Atk';
    if (name == 'special-defense') return 'Sp. Def';
    return name[0].toUpperCase() + name.substring(1);
  }
}
