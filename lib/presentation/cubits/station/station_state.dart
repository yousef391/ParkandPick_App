part of 'station_cubit.dart';

abstract class StationState extends Equatable {
  const StationState();

  @override
  List<Object?> get props => [];
}

class StationInitial extends StationState {
  const StationInitial();
}

class StationLoading extends StationState {
  const StationLoading();
}

class StationLoaded extends StationState {
  final List<Station> stations;
  final List<Station> nearbyStations;
  final Station? selectedStation;
  final bool isConfirming;

  const StationLoaded({
    required this.stations,
    this.nearbyStations = const [],
    this.selectedStation,
    this.isConfirming = false,
  });

  @override
  List<Object?> get props =>
      [stations, nearbyStations, selectedStation, isConfirming];

  StationLoaded copyWith({
    List<Station>? stations,
    List<Station>? nearbyStations,
    Station? selectedStation,
    bool? isConfirming,
    bool clearSelectedStation = false,
  }) {
    return StationLoaded(
      stations: stations ?? this.stations,
      nearbyStations: nearbyStations ?? this.nearbyStations,
      selectedStation: clearSelectedStation
          ? null
          : (selectedStation ?? this.selectedStation),
      isConfirming: isConfirming ?? this.isConfirming,
    );
  }
}

class StationError extends StationState {
  final String message;
  const StationError(this.message);

  @override
  List<Object?> get props => [message];
}

class StationConfirmSuccess extends StationState {
  const StationConfirmSuccess();
}
