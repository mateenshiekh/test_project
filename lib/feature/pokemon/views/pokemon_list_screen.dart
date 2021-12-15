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
    return BlocConsumer<PokemonBloc, PokemonState>(listener: (context, state) {
      if (state is PokemonInitState) {
        context.read<PokemonBloc>().getAllPokemon();
      }
    }, builder: (context, state) {
      if (state is PokemonLoadingState) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state is PokemonFailureState) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error.toString())));
      }

      if (state is PokemonLoadedState) {
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
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    onLongPress: () async {
                      final userInfo = await context
                          .read<AuthenticationBloc>()
                          .getUserInfo();

                      await context.read<PokemonBloc>().markFavPokemon(
                          userInfo, state.pokemons[index].name!);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "${state.pokemons[index].name!} marked as favourites")));
                    },
                    title: Text(state.pokemons[index].name!),
                  );
                },
                itemCount: state.pokemons.length,
              ),
            ),
          ),
        );
      }

      return Container();
    });
  }
}
