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
    emit(ProfileLoading());
    final user = repository.getCurrentUser();
    if (user != null) {
      emit(ProfileSuccess(user));
    } else {
      emit(ProfileError("No user found"));
    }
  }

  Future<void> logout() async {
    try {
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
      loadUserProfile();
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> resetPassword() async {
    emit(ProfileLoading());
    try {
      await repository.sendPasswordReset();
      emit(ProfileResetEmailSent());

      loadUserProfile();
    } catch (e) {
      emit(ProfileError(e.toString()));
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
