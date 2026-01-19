import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testtt/core/failure.dart';

/// Location Repository - Handles geolocation operations
abstract class LocationRepository {
  Future<Either<Failure, Position>> getCurrentLocation();
  double? distanceTo(Position? currentPosition, double lat, double lng);
  Future<bool> openSettings();
}

@LazySingleton(as: LocationRepository)
class LocationRepositoryImpl implements LocationRepository {
  @override
  Future<Either<Failure, Position>> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(
            LocationFailure('Les services de localisation sont désactivés'));
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(
              LocationFailure('Permission de localisation refusée'));
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(LocationFailure(
            'Permission de localisation refusée définitivement'));
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      return Right(position);
    } catch (e) {
      return Left(LocationFailure('Erreur de localisation: $e'));
    }
  }

  @override
  double? distanceTo(Position? currentPosition, double lat, double lng) {
    if (currentPosition == null) return null;
    return Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      lat,
      lng,
    );
  }

  @override
  Future<bool> openSettings() async {
    return await Geolocator.openAppSettings();
  }
}
