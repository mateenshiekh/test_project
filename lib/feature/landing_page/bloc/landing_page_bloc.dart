import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPageCubit extends Cubit<LandingPageState> {
  LandingPageCubit() : super(const LandingPageState(NavigationResult.initial));

  Future<void> isUserLoggedIn() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString("TOKEN");
    if (token == null || token.isEmpty) {
      emit(const LandingPageState(NavigationResult.signIn));
    } else {
      emit(const LandingPageState(NavigationResult.home));
    }
  }
}

class LandingPageState extends Equatable {
  const LandingPageState(this.navigationResult);

  final NavigationResult navigationResult;

  @override
  List<Object> get props => [];
}

enum NavigationResult { initial, signIn, home }
