import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/profile_repository.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final User user;
  ProfileSuccess(this.user);
}

class ProfileDeleted extends ProfileState {}

class ProfileLoggedOut extends ProfileState {}

class ProfileResetEmailSent extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit(this.repository) : super(ProfileInitial());

  void loadUserProfile() {
    final user = repository.getCurrentUser();
    if (user != null) {
      emit(ProfileSuccess(user));
    } else {
      emit(ProfileError("No user session found. Please login again."));
    }
  }

  Future<void> logout() async {
    try {
      emit(ProfileLoading());
      await repository.logout();
      emit(ProfileLoggedOut());
    } catch (e) {
      emit(ProfileError("Logout failed: ${e.toString()}"));
    }
  }

  Future<void> updateUserData(String name, String avatarPath) async {
    emit(ProfileLoading());
    try {
      await repository.updateProfile(name: name, avatarPath: avatarPath);

      final updatedUser = repository.getCurrentUser();
      if (updatedUser != null) {
        emit(ProfileSuccess(updatedUser));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> resetPassword(String email) async {
    emit(ProfileLoading());
    try {
      await repository.sendPasswordReset(email);
      emit(ProfileResetEmailSent());
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> sendPasswordResetToCurrent() async {
    final user = repository.getCurrentUser();
    if (user != null && user.email != null) {
      await resetPassword(user.email!);
    } else {
      emit(ProfileError("Could not find user email."));
    }
  }

  Future<void> deleteAccount() async {
    emit(ProfileLoading());
    try {
      await repository.deleteUserAccount();
      emit(ProfileDeleted());
    } catch (e) {
      emit(ProfileError(e.toString().replaceAll("Exception: ", "")));
    }
  }
}
