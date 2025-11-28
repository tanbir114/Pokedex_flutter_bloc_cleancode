class PokemonListModel {
  final int id;
  final String name;
  final String url;
  final String imageUrl;
  final String primaryType;
  final List<String> types;

  PokemonListModel({
    required this.id,
    required this.name,
    required this.url,
    required this.imageUrl,
    required this.primaryType,
    required this.types,
  });

  // Helper to format ID as #001
  String get formattedId => "#${id.toString().padLeft(3, '0')}";
}
