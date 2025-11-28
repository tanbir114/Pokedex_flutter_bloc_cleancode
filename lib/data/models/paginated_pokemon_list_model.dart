import 'pokemon_list_model.dart';

class PaginatedPokemonList {
  final List<PokemonListModel> pokemonList;
  final String? nextUrl;

  PaginatedPokemonList({required this.pokemonList, this.nextUrl});
}
