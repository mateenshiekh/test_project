import 'package:case_study/feature/auth/domain/auth_models.dart';
import 'package:case_study/feature/pokemon/domain/pokemon_model.dart';
import 'package:case_study/feature/pokemon/domain/pokemon_repository.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonBloc extends Cubit<PokemonState> {
  PokemonBloc() : super(PokemonInitState());
  PokemonRepository _pokemonRepository = PokemonRepository(Dio());

  void getAllPokemon() async {
    emit(PokemonLoadingState());
    try {
      final result = await _pokemonRepository.getAllPokemon();
      emit(PokemonLoadedState(pokemons: result));
    } catch (e) {
      emit(PokemonFailureState(error: e.toString()));
    }
  }

  Future markFavPokemon(UserMap userMap, String name) async {
    return await _pokemonRepository.markPokemonFav(userMap.uid, name);
  }
}

abstract class PokemonState extends Equatable {
  @override
  List<Object> get props => [];
}

class PokemonInitState extends PokemonState {}

class PokemonLoadingState extends PokemonState {}

class PokemonFailureState extends PokemonState {
  final error;
  PokemonFailureState({this.error});
}

class PokemonLoadedState extends PokemonState {
  final List<Pokemon> pokemons;
  PokemonLoadedState({required this.pokemons});
}
