import 'package:case_study/core/route/route_delegate.dart';
import 'package:case_study/feature/auth/bloc/auth_bloc.dart';
import 'package:case_study/feature/landing_page/bloc/landing_page_bloc.dart';
import 'package:case_study/feature/pokemon/bloc/pokemon_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/localization/l10n.dart';

import 'feature/pokemon/bloc/fav_pokemon_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routerDelegate = MyRouterDelegate();
  MyApp() {
    routerDelegate.pushPage(name: '/');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LandingPageCubit(),
        ),
        BlocProvider(create: (context) => AuthenticationBloc()),
        BlocProvider(
          create: (context) => PokemonBloc(),
        ),
        BlocProvider(
          create: (context) => FavPokemonBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Case Study',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: [
          FormBuilderLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', ''),
          Locale('es', ''),
          Locale('fa', ''),
          Locale('fr', ''),
          Locale('ja', ''),
          Locale('pt', ''),
          Locale('sk', ''),
          Locale('pl', ''),
        ],
        debugShowCheckedModeBanner: false,
        home: Router(
          routerDelegate: routerDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
