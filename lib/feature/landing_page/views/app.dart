import 'package:case_study/core/route/route_delegate.dart';
import 'package:case_study/feature/landing_page/bloc/landing_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);
  final routerDelegate = MyRouterDelegate();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LandingPageCubit, LandingPageState>(
      listener: (context, state) {
        switch (state.navigationResult) {
          case NavigationResult.signIn:
            routerDelegate.pushPage(name: '/signIn');
            break;
          case NavigationResult.home:
            routerDelegate.pushPage(name: '/home');
            break;
          default:
        }
      },
      builder: (context, state) {
        if (state.navigationResult == NavigationResult.initial) {
          context.read<LandingPageCubit>().isUserLoggedIn();
        }
        return Container();
      },
    );
  }
}
