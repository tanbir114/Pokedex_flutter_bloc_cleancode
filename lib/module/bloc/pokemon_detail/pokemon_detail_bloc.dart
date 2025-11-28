import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/pokemon_detail_model.dart';
import '../../../data/repositories/pokemon_repository.dart';

// Events
abstract class PokemonDetailEvent extends Equatable {
  const PokemonDetailEvent();
  @override
  List<Object> get props => [];
}

class FetchPokemonDetail extends PokemonDetailEvent {
  final String url;
  const FetchPokemonDetail(this.url);
  @override
  List<Object> get props => [url];
}

// States
abstract class PokemonDetailState extends Equatable {
  const PokemonDetailState();
  @override
  List<Object> get props => [];
}

class PokemonDetailInitial extends PokemonDetailState {}

class PokemonDetailLoading extends PokemonDetailState {}

class PokemonDetailLoaded extends PokemonDetailState {
  final PokemonDetailModel pokemonDetail;
  const PokemonDetailLoaded(this.pokemonDetail);
  @override
  List<Object> get props => [pokemonDetail];
}

class PokemonDetailError extends PokemonDetailState {
  final String message;
  const PokemonDetailError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class PokemonDetailBloc extends Bloc<PokemonDetailEvent, PokemonDetailState> {
  final PokemonRepository repository;

  PokemonDetailBloc(this.repository) : super(PokemonDetailInitial()) {
    on<FetchPokemonDetail>((event, emit) async {
      emit(PokemonDetailLoading());
      try {
        final detail = await repository.fetchPokemonDetails(event.url);
        emit(PokemonDetailLoaded(detail));
      } catch (e) {
        emit(PokemonDetailError("Failed to load details."));
      }
    });
  }
}
