import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:testtt/data/models/station_model.dart';
import 'package:testtt/data/repositories/station_repository.dart';

part 'station_state.dart';

@injectable
class StationCubit extends Cubit<StationState> {
  final StationRepository _stationRepository;

  StationCubit(this._stationRepository) : super(const StationInitial());

  /// Load mock stations
  void loadMockStations() {
    emit(const StationLoading());
    Future.delayed(const Duration(milliseconds: 800), () async {
      final result = await _stationRepository.fetchStations();
      result.fold(
        (failure) => emit(StationError(failure.message)),
        (stations) => emit(StationLoaded(stations: stations)),
      );
    });
  }

  /// Fetch stations from API
  Future<void> fetchStations() async {
    emit(const StationLoading());
    final result = await _stationRepository.fetchStations();
    result.fold(
      (failure) => emit(StationError(failure.message)),
      (stations) => emit(StationLoaded(stations: stations)),
    );
  }

  /// Load stations with user location for distance calculation
  Future<void> loadStationsWithLocation(double userLat, double userLng) async {
    emit(const StationLoading());
    final result =
        await _stationRepository.loadStationsWithLocation(userLat, userLng);
    result.fold(
      (failure) => emit(StationError(failure.message)),
      (stations) => emit(StationLoaded(
        stations: stations,
        nearbyStations: stations,
      )),
    );
  }

  /// Select a station by ID
  void selectStation(String stationId) {
    final currentState = state;
    if (currentState is StationLoaded) {
      try {
        final station =
            currentState.stations.firstWhere((s) => s.id == stationId);
        emit(currentState.copyWith(selectedStation: station));
      } catch (e) {
        emit(const StationError('Station not found'));
      }
    }
  }

  /// Deselect current station
  void deselectStation() {
    final currentState = state;
    if (currentState is StationLoaded) {
      emit(currentState.copyWith(clearSelectedStation: true));
    }
  }

  /// Confirm pickup at selected station
  Future<bool> confirmPickup(String orderId) async {
    final currentState = state;
    if (currentState is! StationLoaded) return false;

    if (currentState.selectedStation == null) {
      emit(const StationError('Please select a pickup station'));
      return false;
    }

    emit(currentState.copyWith(isConfirming: true));

    final result = await _stationRepository.confirmPickup(
      orderId,
      currentState.selectedStation!,
    );

    return result.fold(
      (failure) {
        emit(StationError(failure.message));
        return false;
      },
      (success) {
        emit(const StationConfirmSuccess());
        return true;
      },
    );
  }

  /// Clear error
  void clearError() {
    final currentState = state;
    if (currentState is StationLoaded) {
      emit(currentState.copyWith());
    }
  }

  /// Retry loading
  Future<void> retry() async {
    await fetchStations();
  }

  /// Reset state
  void reset() {
    emit(const StationInitial());
  }
}
