import 'package:case_study/feature/auth/domain/auth_models.dart';
import 'package:case_study/feature/auth/domain/auth_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc extends Cubit<AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  AuthenticationBloc() : super(AuthInitState());

  void signIn({required email, required password}) async {
    emit(AuthLoadingState());
    try {
      final result =
          await _authRepository.signIn(email: email, password: password);
      emit(SignInState(userCredential: result));
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }

  void register({required email, required password}) async {
    emit(AuthLoadingState());
    try {
      final result =
          await _authRepository.registerUser(email: email, password: password);
      emit(UserCreatedState(userCredential: result));
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }

  void getToken() async {
    emit(AuthLoadingState());
    try {
      final result = await _authRepository.getUserToken();
      if (result == null || result.isEmpty)
        emit(FreshUserState());
      else
        emit(LoggedInState());
    } catch (e) {
      emit(AuthFailureState(error: e.toString()));
    }
  }

  Future<UserMap> getUserInfo() async {
    final result = await _authRepository.userInfo();
    return result;
  }

  void logout() async {
    await _authRepository.logout();
  }
}

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitState extends AuthState {}

class AuthLoadingState extends AuthState {}

class LoggedInState extends AuthState {}

class FreshUserState extends AuthState {}

class SignInState extends AuthState {
  final UserCredential userCredential;
  SignInState({required this.userCredential});
}

class UserCreatedState extends AuthState {
  final UserCredential userCredential;
  UserCreatedState({required this.userCredential});
}

class AuthFailureState extends AuthState {
  final error;
  AuthFailureState({this.error});
}
