import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testtt/data/repositories/location_repository.dart';

part 'location_state.dart';

@injectable
class LocationCubit extends Cubit<LocationState> {
  final LocationRepository _locationRepository;

  LocationCubit(this._locationRepository) : super(const LocationInitial());

  /// Get current location with permission handling
  Future<bool> getCurrentLocation() async {
    emit(const LocationLoading());

    final result = await _locationRepository.getCurrentLocation();

    return result.fold(
      (failure) {
        emit(LocationError(
          failure.message,
          permissionDenied: failure.message.contains('refusée'),
        ));
        return false;
      },
      (position) {
        emit(LocationLoaded(position));
        return true;
      },
    );
  }

  /// Get latitude from current state
  double? get latitude {
    final currentState = state;
    if (currentState is LocationLoaded) {
      return currentState.latitude;
    }
    return null;
  }

  /// Get longitude from current state
  double? get longitude {
    final currentState = state;
    if (currentState is LocationLoaded) {
      return currentState.longitude;
    }
    return null;
  }

  /// Calculate distance to a point
  double? distanceTo(double lat, double lng) {
    final currentState = state;
    if (currentState is LocationLoaded) {
      return _locationRepository.distanceTo(currentState.position, lat, lng);
    }
    return null;
  }

  /// Open app settings for location permission
  Future<bool> openSettings() async {
    return await _locationRepository.openSettings();
  }
}
