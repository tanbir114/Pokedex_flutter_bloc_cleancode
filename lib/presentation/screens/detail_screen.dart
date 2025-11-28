import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/pokemon_detail_model.dart';
import '../../data/repositories/pokemon_repository.dart';
import '../../module/bloc/pokemon_detail/pokemon_detail_bloc.dart';
import '../../theme/pokemon_colors.dart';
import '../widgets/detail_widgets/detail_tabs_container.dart';
import '../widgets/detail_widgets/pokemon_header.dart';

class DetailScreen extends StatelessWidget {
  final String name;
  final String url;
  final int id;
  final String primaryType;

  const DetailScreen({
    super.key,
    required this.name,
    required this.url,
    required this.id,
    required this.primaryType,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = PokemonColors.getColor(primaryType);

    return BlocProvider(
      create: (context) =>
          PokemonDetailBloc(RepositoryProvider.of<PokemonRepository>(context))
            ..add(FetchPokemonDetail(url)),
      child: Scaffold(
        backgroundColor: cardColor,
        appBar: AppBar(
          backgroundColor: cardColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: BlocBuilder<PokemonDetailBloc, PokemonDetailState>(
          builder: (context, state) {
            if (state is PokemonDetailLoading) {
              return _buildLoadingState(name, cardColor);
            } else if (state is PokemonDetailLoaded) {
              return _buildLoadedState(context, state.pokemonDetail, cardColor);
            } else if (state is PokemonDetailError) {
              return _buildErrorState(state.message);
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState(String name, Color color) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 16),

          Text(
            "Loading ${name[0].toUpperCase() + name.substring(1)}'s details...",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(
    BuildContext context,
    PokemonDetailModel details,
    Color cardColor,
  ) {
    return Column(
      children: [
        PokemonHeader(details: details, cardColor: cardColor),
        Expanded(
          child: DetailTabsContainer(details: details, cardColor: cardColor),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Error fetching details: $message",
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
