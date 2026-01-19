part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserLoaded extends UserState {
  final UserProfile user;
  final bool isUpdating;

  const UserLoaded({required this.user, this.isUpdating = false});

  @override
  List<Object?> get props => [user, isUpdating];

  UserLoaded copyWith({
    UserProfile? user,
    bool? isUpdating,
  }) {
    return UserLoaded(
      user: user ?? this.user,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }
}

class UserError extends UserState {
  final String message;
  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
