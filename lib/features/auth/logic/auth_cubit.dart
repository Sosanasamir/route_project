// lib/features/auth/logic/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/utils/firebase_functions.dart';
import 'auth_sates.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  // 1. Used by LoginScreen
  void login(String email, String password) async {
    emit(AuthLoading());
    await FirebaseFunctions.login(
      email,
      password,
      onSuccess: () => emit(AuthSuccess()),
      onError: (message) => emit(AuthError(message)),
    );
  }

  // 2. Used by RegisterScreen
  void register(String email, String password, String name) async {
    emit(AuthLoading());
    await FirebaseFunctions.createUser(
      email,
      password,
      name,
      onSuccess: () => emit(AuthSuccess()),
      onError: (message) => emit(AuthError(message)),
    );
  }
}
