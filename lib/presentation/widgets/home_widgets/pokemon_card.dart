import 'package:flutter/material.dart';
import '../../../data/models/pokemon_list_model.dart'; // Using the List Model
import '../../../theme/pokemon_colors.dart';
import '../type_badge.dart';

class PokemonCard extends StatelessWidget {
  final PokemonListModel pokemon; // Accepts the List Model
  final VoidCallback onTap;

  const PokemonCard({Key? key, required this.pokemon, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = PokemonColors.getColor(pokemon.primaryType);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16, top: 10, bottom: 20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Index Number (#001) at top right, faint
            Positioned(
              top: 0,
              right: 0,
              child: Text(
                pokemon.formattedId, // Using formattedId from the model
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),

            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image (Larger and lifted for a modern look)
                Hero(
                  tag: pokemon.id,
                  child: Image.network(
                    pokemon.imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),

                // Name
                Text(
                  pokemon.name[0].toUpperCase() + pokemon.name.substring(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pokemon.types.map((type) {
                    // Only display up to two types for compactness on the card
                    if (pokemon.types.indexOf(type) >= 2)
                      return const SizedBox.shrink();

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TypeBadge(
                        type: type,
                      ), // Assuming TypeBadge handles styling for a single type
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
