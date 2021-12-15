import 'package:case_study/feature/auth/domain/auth_models.dart';
import 'package:case_study/feature/pokemon/domain/pokemon_model.dart';
import 'package:case_study/feature/pokemon/domain/pokemon_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavPokemonBloc extends Cubit<FavPokemonState> {
  FavPokemonBloc() : super(FavPokemonInitState());
  PokemonRepository _pokemonRepository = PokemonRepository(Dio());

  void getFavPokemon(UserMap userMap) async {
    emit(FavPokemonLoadingState());
    try {
      final result = await _pokemonRepository.getFavPokemons(userMap.uid);
      print(result);
      emit(FavPokemonLoadedState(pokemons: result));
    } catch (e) {
      emit(FavPokemonFailureState(error: e.toString()));
    }
  }
}

abstract class FavPokemonState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavPokemonInitState extends FavPokemonState {}

class FavPokemonLoadingState extends FavPokemonState {}

class FavPokemonFailureState extends FavPokemonState {
  final error;
  FavPokemonFailureState({this.error});
}

class FavPokemonLoadedState extends FavPokemonState {
  final List<Pokemon> pokemons;
  FavPokemonLoadedState({required this.pokemons});
}
