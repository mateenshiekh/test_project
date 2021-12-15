import 'package:case_study/feature/auth/views/sign_in_screen.dart';
import 'package:case_study/feature/auth/views/sign_up_screen.dart';
import 'package:case_study/feature/landing_page/views/app.dart';
import 'package:case_study/feature/pokemon/views/fav_pokemon_list_screen.dart';
import 'package:case_study/feature/pokemon/views/pokemon_list_screen.dart';
import 'package:flutter/material.dart';

class MyRouterDelegate extends RouterDelegate<List<RouteSettings>>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  static MyRouterDelegate _instance = MyRouterDelegate._internal();
  MyRouterDelegate._internal();

  factory MyRouterDelegate() {
    return _instance;
  }

  final _pages = <Page>[];

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: List.of(_pages),
      key: navigatorKey,
      onPopPage: _onPopPage,
    );
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(List<RouteSettings> configuration) {
    throw UnimplementedError();
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1) {
      _pages.removeLast();
      notifyListeners();
      return Future.value(true);
    }
    return _confirmAppExit();
  }

  Future<bool> _confirmAppExit() async {
    return (await showDialog<bool>(
            context: _navigatorKey.currentContext!,
            builder: (context) {
              return AlertDialog(
                title: const Text('Exit App'),
                content: const Text('Are you sure you want to exit the app?'),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context, true),
                  ),
                  TextButton(
                    child: const Text('Confirm'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              );
            })) ??
        false;
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  void pushPage({@required String? name, dynamic arguments}) {
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }

  void pushAndRemoveUntilPage({@required String? name, dynamic arguments}) {
    _pages.clear();
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget? child;

    switch (routeSettings.name) {
      case '/':
        child = App();
        break;
      case '/signIn':
        child = SignInScreen();
        break;
      case '/signUp':
        child = SignUpScreen();
        break;
      case '/home':
        child = PokemonListScreen();
        break;
      case '/favPokemons':
        child = FavPokemonListScreen();
        break;
    }

    return MaterialPage(
        child: child!,
        name: routeSettings.name,
        arguments: routeSettings.arguments,
        key: ObjectKey(routeSettings.name));
  }
}
