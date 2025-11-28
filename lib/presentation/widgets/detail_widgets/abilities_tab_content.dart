import 'package:flutter/material.dart';

import '../../../data/models/pokemon_detail_model.dart';
import 'ability_chip.dart';

class AbilitiesTabContent extends StatelessWidget {
  final PokemonDetailModel details;
  final Color color;

  const AbilitiesTabContent({
    Key? key,
    required this.details,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Abilities (${details.abilities.length})",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 15),

          Wrap(
            spacing: 12.0,
            runSpacing: 12.0,
            children: details.abilities
                .map(
                  (ability) =>
                      AbilityChip(name: ability.formattedName, color: color),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
