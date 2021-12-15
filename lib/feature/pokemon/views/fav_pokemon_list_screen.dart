import 'package:case_study/core/route/route_delegate.dart';
import 'package:case_study/feature/auth/bloc/auth_bloc.dart';
import 'package:case_study/feature/pokemon/bloc/fav_pokemon_bloc.dart';
import 'package:case_study/feature/pokemon/bloc/pokemon_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavPokemonListScreen extends StatelessWidget {
  FavPokemonListScreen({Key? key}) : super(key: key);
  final routerDelegate = MyRouterDelegate();

  @override
  Widget build(BuildContext context) {
    context
        .read<AuthenticationBloc>()
        .getUserInfo()
        .then((value) => context.read<FavPokemonBloc>().getFavPokemon(value));
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: BlocBuilder<FavPokemonBloc, FavPokemonState>(
            builder: (context, state) {
          if (state is FavPokemonLoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is FavPokemonFailureState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error.toString())));
          }

          if (state is FavPokemonLoadedState) {
            return ListView.builder(
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(state.pokemons[index].name!),
                );
              },
              itemCount: state.pokemons.length,
            );
          }
          return Container();
        }),
      ),
    );
  }
}
