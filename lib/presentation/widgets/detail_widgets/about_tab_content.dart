import 'package:flutter/material.dart';

import '../../../data/models/pokemon_detail_model.dart';
import '../../../data/models/sprite_item_model.dart';
import 'detail_stat_item.dart';
import '../type_badge.dart';

class AboutTabContent extends StatelessWidget {
  final PokemonDetailModel details;
  final Color color;

  const AboutTabContent({Key? key, required this.details, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<SpriteItem> sprites = details.spriteUrls;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (sprites.isNotEmpty) ...[
            Text(
              "Sprites",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 15),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: sprites.map((spriteItem) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Image.network(
                            spriteItem.url,
                            height: 80,
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          spriteItem
                              .name, // Display the name from the SpriteItem
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 30),
          ],

          // --- Physical Traits Section ---
          Text(
            "Physical Traits",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DetailStatItem(
                label: "Height",
                value: "${details.height / 10} m",
                color: color,
              ),
              DetailStatItem(
                label: "Weight",
                value: "${details.weight / 10} kg",
                color: color,
              ),
            ],
          ),
          const SizedBox(height: 30),

          // --- Elemental Types Section ---
          Text(
            "Elemental Types",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: details.types
                .map((type) => TypeBadge(type: type))
                .toList(),
          ),
        ],
      ),
    );
  }
}
