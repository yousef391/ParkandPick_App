import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:testtt/data/repositories/user_repository.dart';

part 'user_state.dart';

@injectable
class UserCubit extends Cubit<UserState> {
  final UserRepository _userRepository;

  UserCubit(this._userRepository) : super(const UserInitial()) {
    loadCurrentUser();
  }

  Future<void> loadCurrentUser() async {
    final result = await _userRepository.getProfile();
    result.fold(
      (failure) => emit(const UserInitial()), // Or error state
      (user) => emit(UserLoaded(user: user)),
    );
  }

  /// Update user profile
  Future<void> updateProfile({String? name, String? email}) async {
    final currentState = state;
    if (currentState is UserLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      final result =
          await _userRepository.updateProfile(name: name, email: email);

      result.fold(
        (failure) => emit(UserError(failure.message)),
        (user) => emit(UserLoaded(user: user)),
      );
    }
  }

  /// Update avatar path
  Future<void> updateAvatar(String? avatarPath) async {
    final currentState = state;
    if (currentState is UserLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      final result = await _userRepository.updateAvatar(avatarPath);

      result.fold(
        (failure) => emit(UserError(failure.message)),
        (user) => emit(UserLoaded(user: user)),
      );
    }
  }

  /// Upload avatar from file
  Future<void> uploadAvatar(File imageFile) async {
    final currentState = state;
    if (currentState is UserLoaded) {
      emit(currentState.copyWith(isUpdating: true));

      final result = await _userRepository.uploadAvatar(imageFile);

      result.fold(
        (failure) => emit(UserError(failure.message)),
        (user) => emit(UserLoaded(user: user)),
      );
    }
  }

  /// Get current user (convenience getter)
  UserProfile? get currentUser {
    final currentState = state;
    if (currentState is UserLoaded) {
      return currentState.user;
    }
    return null;
  }
}
