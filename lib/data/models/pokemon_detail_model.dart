import 'pokemon_ability_model.dart';
import 'pokemon_learned_move_model.dart';
import 'pokemon_stat_model.dart';
import 'sprite_item_model.dart';

class PokemonDetailModel {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final List<PokemonStat> stats;
  final List<PokemonAbility> abilities;
  final List<PokemonLearnedMove> moves;
  final List<String> availableVersionGroups;
  final TypeEffectivenessModel effectiveness;
  final Map<String, dynamic> rawSprites;

  PokemonDetailModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.moves,
    required this.availableVersionGroups,
    required this.effectiveness,
    required this.rawSprites,
  });

  List<SpriteItem> get spriteUrls {
    final List<SpriteItem> sprites = [];

    const Map<String, String> spriteKeyMap = {
      'front_default': 'Default',
      'back_default': 'Back Default',
      'front_shiny': 'Shiny',
      'back_shiny': 'Back Shiny',
      'front_female': 'Female',
      'back_female': 'Back Female',
      'front_shiny_female': 'Shiny Female',
      'back_shiny_female': 'Back Shiny Female',
    };

    final officialArt = rawSprites['other']?['official-artwork'];
    final shinyArtUrl = officialArt?['front_shiny'];
    if (shinyArtUrl is String && shinyArtUrl.isNotEmpty) {
      sprites.add(SpriteItem(name: 'Official Shiny', url: shinyArtUrl));
    }

    spriteKeyMap.forEach((key, name) {
      final url = rawSprites[key];
      if (url is String && url.isNotEmpty) {
        sprites.add(SpriteItem(name: name, url: url));
      }
    });

    final uniqueUrls = <String>{};
    return sprites.where((item) => uniqueUrls.add(item.url)).toList();
  }
}
