import 'package:flutter/material.dart';
import '../../../data/models/pokemon_detail_model.dart';
import 'about_tab_content.dart';
import 'base_stats_tab_content.dart';
import 'abilities_tab_content.dart';
import 'moves_tab_content.dart';

class DetailTabsContainer extends StatelessWidget {
  final PokemonDetailModel details;
  final Color cardColor;

  const DetailTabsContainer({
    Key? key,
    required this.details,
    required this.cardColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                children: [
                  AboutTabContent(details: details, color: cardColor),
                  BaseStatsTabContent(details: details, color: cardColor),
                  AbilitiesTabContent(details: details, color: cardColor),
                  MovesTabContent(details: details, color: cardColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: cardColor,
      unselectedLabelColor: Colors.grey,
      indicatorColor: cardColor,
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      tabs: const [
        Tab(text: "About"),
        Tab(text: "Base Stats"),
        Tab(text: "Abilities"),
        Tab(text: "Moves"),
      ],
    );
  }
}
