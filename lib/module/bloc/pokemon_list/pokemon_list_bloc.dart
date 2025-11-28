import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/pokemon_list_model.dart';
import '../../../data/repositories/pokemon_repository.dart';

// Events
abstract class PokemonListEvent extends Equatable {
  const PokemonListEvent();

  @override
  List<Object> get props => [];
}

class FetchPokemonList extends PokemonListEvent {}

class LoadMorePokemon extends PokemonListEvent {}

// States
abstract class PokemonListState extends Equatable {
  const PokemonListState();
  @override
  List<Object> get props => [];
}

class PokemonListInitial extends PokemonListState {}

class PokemonListLoading extends PokemonListState {}

class PokemonListLoaded extends PokemonListState {
  final List<PokemonListModel> pokemonList;
  final String? nextUrl; 
  final bool isLoadingMore; 

  const PokemonListLoaded({
    required this.pokemonList,
    this.nextUrl,
    this.isLoadingMore = false,
  });

  PokemonListLoaded copyWith({
    List<PokemonListModel>? pokemonList,
    String? nextUrl,
    bool? isLoadingMore,
  }) {
    return PokemonListLoaded(
      pokemonList: pokemonList ?? this.pokemonList,
      nextUrl: nextUrl,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object> get props => [pokemonList, nextUrl ?? '', isLoadingMore];
}

class PokemonListError extends PokemonListState {
  final String message;
  const PokemonListError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class PokemonListBloc extends Bloc<PokemonListEvent, PokemonListState> {
  final PokemonRepository repository;

  PokemonListBloc({required this.repository}) : super(PokemonListInitial()) {
    on<FetchPokemonList>(_onFetchPokemonList);
    on<LoadMorePokemon>(_onLoadMorePokemon);
  }

  Future<void> _onFetchPokemonList(
    FetchPokemonList event,
    Emitter<PokemonListState> emit,
  ) async {
    emit(PokemonListLoading());
    try {
      final paginatedList = await repository.fetchPokemonList();
      
      emit(PokemonListLoaded(
        pokemonList: paginatedList.pokemonList,
        nextUrl: paginatedList.nextUrl,
      ));
    } catch (e) {
      emit(PokemonListError('Failed to load initial list: ${e.toString()}'));
    }
  }

  Future<void> _onLoadMorePokemon(
    LoadMorePokemon event,
    Emitter<PokemonListState> emit,
  ) async {
    final currentState = state;
    
    if (currentState is PokemonListLoaded && 
        !currentState.isLoadingMore && 
        currentState.nextUrl != null) {
      
      emit(currentState.copyWith(isLoadingMore: true));

      try {
        final paginatedList = await repository.fetchPokemonList(url: currentState.nextUrl);
        final updatedList = List.of(currentState.pokemonList)..addAll(paginatedList.pokemonList);
        emit(PokemonListLoaded(
          pokemonList: updatedList,
          nextUrl: paginatedList.nextUrl,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
        print('Error loading more Pokémon: $e'); 
      }
    }
  }
}
