import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../module/bloc/pokemon_list/pokemon_list_bloc.dart';
import '../widgets/home_widgets/pokemon_card.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Start listening for scroll events
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Scroll detection logic
  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Check if the user is within 200 pixels of the end of the list
    if (maxScroll - currentScroll <= 200) {
      // Trigger the LoadMore event if needed
      context.read<PokemonListBloc>().add(LoadMorePokemon());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pokedex Explorer"),
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              "Explore all Pokémon!",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text(
              "Pokémon List:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),

          // Fixed height container for the horizontal list
          SizedBox(
            height: 280,
            child: BlocBuilder<PokemonListBloc, PokemonListState>(
              builder: (context, state) {
                if (state is PokemonListLoading ||
                    state is PokemonListInitial) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.redAccent),
                  );
                } else if (state is PokemonListLoaded) {
                  return _buildHorizontalList(context, state);
                } else if (state is PokemonListError) {
                  return Center(
                    child: Text(
                      'Error: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }
                return const Center(child: Text("Start exploring Pokémon!"));
              },
            ),
          ),

          const Expanded(child: SizedBox.shrink()),
        ],
      ),
    );
  }

  // List builder is modified to handle the ScrollController and loading indicator
  Widget _buildHorizontalList(BuildContext context, PokemonListLoaded state) {
    // Add 1 to itemCount if there's a next page URL (for the loader)
    final itemCount =
        state.pokemonList.length + (state.nextUrl != null ? 1 : 0);

    return ListView.builder(
      controller: _scrollController, // <-- Attach the controller
      padding: const EdgeInsets.symmetric(horizontal: 16),
      scrollDirection: Axis.horizontal,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        // If it's the last index and there is more data, show the loader
        if (index == state.pokemonList.length && state.nextUrl != null) {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          );
        }

        // Show the regular Pokémon card
        final pokemon = state.pokemonList[index];
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: PokemonCard(
            pokemon: pokemon,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(
                    name: pokemon.name,
                    url: pokemon.url,
                    id: pokemon.id,
                    primaryType: pokemon.primaryType,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
