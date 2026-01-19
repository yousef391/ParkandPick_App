import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:testtt/data/repositories/auth_repository.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result =
        await _authRepository.login(email: email, password: password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (success) => emit(const AuthAuthenticated()),
    );
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    final result = await _authRepository.signup(
      name: name,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (success) => emit(const AuthAuthenticated()),
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    emit(const AuthInitial());
  }
}
