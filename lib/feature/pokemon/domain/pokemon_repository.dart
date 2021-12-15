import 'package:case_study/feature/pokemon/domain/pokemon_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class IPokemonRepository {
  Future<List<Pokemon>> getAllPokemon();
  Future<List<Pokemon>> getFavPokemons(String uid);
  Future markPokemonFav(String uid, String name);
}

class PokemonRepository implements IPokemonRepository {
  Dio client;
  PokemonRepository(this.client);
  SharedPreferences? _sharedPref;

  @override
  Future<List<Pokemon>> getAllPokemon() async {
    final respone = await client.get('https://pokeapi.co/api/v2/pokemon');
    if (respone.statusCode == 200) {
      return respone.data['results']
          .map<Pokemon>((json) => Pokemon.fromJson(json))
          .toList();
    }

    return [];
  }

  @override
  Future markPokemonFav(String uid, String name) async {
    final pref = await _getPref();
    List<String> names = [];

    if (pref.getStringList(uid) != null) {
      names.addAll(pref.getStringList(uid)!);
    }

    if (!names.contains(name)) names.add(name);

    await pref.setStringList(uid, names);
  }

  @override
  Future<List<Pokemon>> getFavPokemons(String uid) async {
    final pref = await _getPref();
    if (pref.getStringList(uid) != null) {
      return pref
          .getStringList(uid)!
          .map<Pokemon>((e) => Pokemon(name: e))
          .toList();
    }
    return [];
  }

  Future<SharedPreferences> _getPref() async {
    if (_sharedPref == null)
      _sharedPref = await SharedPreferences.getInstance();

    return _sharedPref!;
  }
}
