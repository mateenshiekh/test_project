import 'package:case_study/core/route/route_delegate.dart';
import 'package:case_study/feature/auth/bloc/auth_bloc.dart';
import 'package:case_study/feature/pokemon/bloc/pokemon_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PokemonListScreen extends StatelessWidget {
  PokemonListScreen({Key? key}) : super(key: key);
  final routerDelegate = MyRouterDelegate();

  @override
  Widget build(BuildContext context) {
    context.read<PokemonBloc>().getAllPokemon();
    return BlocConsumer<PokemonBloc, PokemonState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is PokemonLoadingState) {
            print("PokemonLoadingState.toString()");
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is PokemonFailureState) {
            print("PokemonFailureState.toString()");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error.toString())));
          }

          if (state is PokemonLoadedState) {
            print("PokemonLoadedState.toString()");
            return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                      onPressed: () {
                        context.read<AuthenticationBloc>().logout();
                        routerDelegate.pushPage(name: '/signIn');
                      },
                      icon: Icon(Icons.power_settings_new_outlined)),
                  title: Text("Home"),
                  actions: [
                    IconButton(
                        onPressed: () =>
                            routerDelegate.pushPage(name: '/favPokemons'),
                        icon: Icon(Icons.favorite))
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        onLongPress: () => context
                            .read<AuthenticationBloc>()
                            .getUserInfo()
                            .then((value) => context
                                .read<PokemonBloc>()
                                .markFavPokemon(
                                    value, state.pokemons[index].name!)),
                        title: Text(state.pokemons[index].name!),
                      );
                    },
                    itemCount: state.pokemons.length,
                  ),
                ),
              ),
            );
          }

          if (state is PokemonInitState) {
            context.read<PokemonBloc>().getAllPokemon();
          }

          return Container();
        });
  }
}
