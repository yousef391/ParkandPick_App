import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_state.dart';

@injectable
@injectable
class OnboardingCubit extends Cubit<OnboardingState> {
  final SharedPreferences _prefs;

  OnboardingCubit(this._prefs) : super(const OnboardingState());

  Future<void> completeOnboarding() async {
    await _prefs.setBool('onboarding_seen', true);
  }

  void setPage(int page) {
    if (page >= 0 && page < state.totalPages) {
      emit(state.copyWith(currentPage: page));
    }
  }

  void nextPage() {
    if (state.currentPage < state.totalPages - 1) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void reset() {
    emit(const OnboardingState());
  }

  /// Convenience getters
  int get currentPage => state.currentPage;
  bool get isLastPage => state.isLastPage;
}
