import 'package:flutter/material.dart';
import '../../../data/models/pokemon_detail_model.dart';
import 'moves_table.dart';

class MovesTabContent extends StatelessWidget {
  final PokemonDetailModel details;
  final Color color;

  const MovesTabContent({Key? key, required this.details, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (details.moves.isEmpty || details.availableVersionGroups.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("No move data available."),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
      child: MovesTable(
        moves: (details).moves,
        availableVersionGroups: details.availableVersionGroups,
        color: color,
      ),
    );
  }
}
