import 'package:flutter/material.dart';

import '../../../data/models/pokemon_detail_model.dart';
import 'stat_progress_bar.dart';
import '../type_badge.dart';

class BaseStatsTabContent extends StatelessWidget {
  final PokemonDetailModel details;
  final Color color;

  const BaseStatsTabContent({
    Key? key,
    required this.details,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalStat = details.stats.fold(0, (sum, stat) => sum + stat.baseStat);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle("Base Stats"),
          const SizedBox(height: 15),

          ...details.stats.map(
            (stat) => StatProgressBar(
              label: stat.formattedName,
              value: stat.baseStat,
              color: color,
            ),
          ),

          const Divider(height: 30),
          _buildTotalStat(totalStat),
          const SizedBox(height: 30),

          _buildTypeEffectiveness(),
        ],
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
    );
  }

  Widget _buildTotalStat(int total) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            "Total",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: color,
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(
          width: 30,
          child: Text(
            total.toString(),
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildTypeEffectiveness() {
    final effectiveness = details.effectiveness;
    final hasData =
        effectiveness.doubleDamageFrom.isNotEmpty ||
        effectiveness.halfDamageFrom.isNotEmpty ||
        effectiveness.noDamageFrom.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle("Type Effectiveness (Weaknesses & Resistances)"),
        const SizedBox(height: 15),

        if (hasData) ...[
          _buildTypeList(
            "Weaknesses (Takes 2x Damage)",
            effectiveness.doubleDamageFrom,
            Colors.red,
          ),
          _buildTypeList(
            "Resistances (Takes 0.5x Damage)",
            effectiveness.halfDamageFrom,
            Colors.green,
          ),
          _buildTypeList(
            "Immunities (Takes 0x Damage)",
            effectiveness.noDamageFrom,
            Colors.blueGrey,
          ),
        ] else
          const Text(
            "No specific weaknesses, resistances, or immunities found.",
            style: TextStyle(color: Colors.grey),
          ),
      ],
    );
  }

  Widget _buildTypeList(String title, List<String> types, Color textColor) {
    if (types.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: types.map((type) => TypeBadge(type: type)).toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
