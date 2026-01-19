part of 'location_cubit.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationLoaded extends LocationState {
  final Position position;

  const LocationLoaded(this.position);

  double get latitude => position.latitude;
  double get longitude => position.longitude;

  @override
  List<Object?> get props => [position];
}

class LocationError extends LocationState {
  final String message;
  final bool permissionDenied;

  const LocationError(this.message, {this.permissionDenied = false});

  @override
  List<Object?> get props => [message, permissionDenied];
}
