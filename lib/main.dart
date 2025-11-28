import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/pokemon_repository.dart';
import 'module/bloc/pokemon_list/pokemon_list_bloc.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => PokemonRepository(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokédex Task',
        theme: ThemeData(primarySwatch: Colors.red, useMaterial3: true),
        // Provide the List BLoC to the Home Screen
        home: BlocProvider(
          create: (context) => PokemonListBloc(
            repository: RepositoryProvider.of<PokemonRepository>(context),
          )..add(FetchPokemonList()),
          child: const HomeScreen(),
        ),
      ),
    );
  }
}
