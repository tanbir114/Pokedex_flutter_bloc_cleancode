import 'package:flutter/material.dart';
import '../../../data/models/pokemon_detail_model.dart';
import '../type_badge.dart';


class PokemonHeader extends StatelessWidget {
  final PokemonDetailModel details;
  final Color cardColor;

  const PokemonHeader({
    Key? key,
    required this.details,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name and ID Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                details.name[0].toUpperCase() + details.name.substring(1),
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              Text(
                "#${details.id.toString().padLeft(3, '0')}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Type Badges
          Row(
            children: details.types
                .map(
                  (type) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TypeBadge(type: type),
                  ),
                )
                .toList(),
          ),

          // Pokemon Image
          Center(
            child: Hero(
              tag: details.id,
              child: Image.network(
                details.imageUrl,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
