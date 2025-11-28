import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/move_detail_model.dart';
import '../models/move_version_detail_model.dart';
import '../models/pokemon_ability_model.dart';
import '../models/pokemon_learned_move_model.dart';
import '../models/pokemon_list_model.dart';
import '../models/pokemon_detail_model.dart';
import '../models/paginated_pokemon_list_model.dart';
import '../models/pokemon_stat_model.dart';

class PokemonRepository {
  final String _initialListUrl =
      'https://pokeapi.co/api/v2/pokemon?limit=20&offset=0';
  final String _typeBaseUrl = 'https://pokeapi.co/api/v2/type/';

  Future<PaginatedPokemonList> fetchPokemonList({String? url}) async {
    final fetchUrl = url ?? _initialListUrl;

    final response = await http.get(Uri.parse(fetchUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      final String? nextUrl = data['next'];

      List<Future<PokemonListModel>> detailFutures = results.map((item) async {
        return await _fetchPokemonListDetails(item['url']);
      }).toList();

      final pokemonList = await Future.wait(detailFutures);

      return PaginatedPokemonList(pokemonList: pokemonList, nextUrl: nextUrl);
    } else {
      throw Exception('Failed to load list from $fetchUrl');
    }
  }

  Future<PokemonListModel> _fetchPokemonListDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final typesJson = json['types'] as List<dynamic>? ?? [];
      List<String> typesList = typesJson
          .map((t) => (t['type']?['name'] as String?) ?? 'unknown')
          .toList();

      final primaryType = typesList.isNotEmpty ? typesList.first : 'unknown';

      return PokemonListModel(
        id: json['id'],
        name: json['name'],
        url: url,
        imageUrl:
            json['sprites']['other']['official-artwork']['front_default'] ??
            json['sprites']['front_default'] ??
            '',
        primaryType: primaryType,
        types: typesList,
      );
    } else {
      throw Exception('Failed to load list details for $url');
    }
  }

  Future<TypeEffectivenessModel> _fetchTypeDetails(String typeName) async {
    final response = await http.get(Uri.parse('$_typeBaseUrl$typeName'));

    if (response.statusCode != 200) {
      return TypeEffectivenessModel(
        doubleDamageFrom: [],
        halfDamageFrom: [],
        noDamageFrom: [],
      );
    }

    try {
      final json = jsonDecode(response.body);
      final damageRelations = json['damage_relations'];

      List<String> getTypes(String key) =>
          (damageRelations[key]?['name'] as List<dynamic>?)
              ?.map((t) => t['name'].toString())
              .toList() ??
          [];

      return TypeEffectivenessModel(
        doubleDamageFrom: getTypes('double_damage_from'),
        halfDamageFrom: getTypes('half_damage_from'),
        noDamageFrom: getTypes('no_damage_from'),
      );
    } catch (e) {
      print("Failed to decode type JSON for $typeName: $e");
      return TypeEffectivenessModel(
        doubleDamageFrom: [],
        halfDamageFrom: [],
        noDamageFrom: [],
      );
    }
  }

  Future<MoveDetailModel> _fetchMoveDetails(String moveUrl) async {
    final response = await http.get(Uri.parse(moveUrl));
    if (response.statusCode != 200) {
      return MoveDetailModel(
        power: null,
        moveType: 'unknown',
        damageClass: 'status',
      );
    }

    try {
      final json = jsonDecode(response.body);
      final power = json['power'] as int?;
      final moveType = json['type']?['name'] as String? ?? 'unknown';
      final damageClass = json['damage_class']?['name'] as String? ?? 'status';

      return MoveDetailModel(
        power: power,
        moveType: moveType,
        damageClass: damageClass,
      );
    } catch (e) {
      print("Error decoding move detail JSON from $moveUrl: $e");
      return MoveDetailModel(
        power: null,
        moveType: 'unknown',
        damageClass: 'status',
      );
    }
  }

  Future<PokemonDetailModel> fetchPokemonDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load full Pokemon details: Status ${response.statusCode}',
      );
    }

    final json = jsonDecode(response.body);

    final typesJson = json['types'] as List<dynamic>? ?? [];
    List<String> typesList = typesJson
        .map((t) => (t['type']?['name'] as String?) ?? 'unknown')
        .toList();

    TypeEffectivenessModel combinedEffectiveness = TypeEffectivenessModel(
      doubleDamageFrom: [],
      halfDamageFrom: [],
      noDamageFrom: [],
    );
    try {
      List<Future<TypeEffectivenessModel>> typeFutures = typesList.map((type) {
        return _fetchTypeDetails(type);
      }).toList();

      List<TypeEffectivenessModel> allTypeData = await Future.wait(typeFutures);
      combinedEffectiveness = TypeEffectivenessModel.combine(allTypeData);
    } catch (e) {
      print("Error fetching type effectiveness: $e");
    }

    List<PokemonLearnedMove> movesList = [];
    Set<String> uniqueVersionGroups = {};
    final movesJson = json['moves'] as List<dynamic>? ?? [];

    List<Future<MoveDetailModel>> moveDetailFutures = [];

    for (var moveEntry in movesJson) {
      final moveData = moveEntry['move'] as Map<String, dynamic>?;
      if (moveData == null) continue;

      String moveName = moveData['name'] as String? ?? 'N/A';
      String moveUrl = moveData['url'] as String? ?? '';

      moveDetailFutures.add(_fetchMoveDetails(moveUrl));

      final versionDetailsJson =
          moveEntry['version_group_details'] as List<dynamic>? ?? [];
      List<MoveVersionDetail> detailsForMove = [];

      for (var versionDetail in versionDetailsJson) {
        String versionName =
            versionDetail['version_group']?['name'] as String? ?? '';
        String method =
            versionDetail['move_learn_method']?['name'] as String? ?? '';
        int level = versionDetail['level_learned_at'] as int? ?? 0;

        if (versionName.isNotEmpty) {
          uniqueVersionGroups.add(versionName);
          detailsForMove.add(
            MoveVersionDetail(
              versionGroup: versionName,
              levelLearned: level,
              learningMethod: method,
            ),
          );
        }
      }

      if (detailsForMove.isNotEmpty && moveName != 'N/A') {
        movesList.add(
          PokemonLearnedMove(
            moveName: moveName,
            moveUrl: moveUrl,
            versionDetails: detailsForMove,
          ),
        );
      }
    }

    List<MoveDetailModel> allMoveDetails = await Future.wait(moveDetailFutures);

    List<PokemonLearnedMove> finalMovesList = [];
    for (int i = 0; i < movesList.length; i++) {
      finalMovesList.add(
        PokemonLearnedMove(
          moveName: movesList[i].moveName,
          moveUrl: movesList[i].moveUrl,
          versionDetails: movesList[i].versionDetails,
          detail: allMoveDetails[i],
        ),
      );
    }

    List<String> sortedVersionGroups = uniqueVersionGroups.toList()..sort();

    return PokemonDetailModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ??
          '',
      types: typesList,
      height: json['height'] as int? ?? 0,
      weight: json['weight'] as int? ?? 0,

      stats: (json['stats'] as List<dynamic>? ?? [])
          .map(
            (s) => PokemonStat(
              name: s['stat']?['name'] as String? ?? 'Unknown',
              baseStat: s['base_stat'] as int? ?? 0,
            ),
          )
          .toList(),

      abilities: (json['abilities'] as List<dynamic>? ?? [])
          .map(
            (a) => PokemonAbility(
              name: a['ability']?['name'] as String? ?? 'Unknown',
            ),
          )
          .toList(),

      moves: finalMovesList,
      availableVersionGroups: sortedVersionGroups,
      effectiveness: combinedEffectiveness,
      rawSprites: json['sprites'] as Map<String, dynamic>? ?? {},
    );
  }
}
