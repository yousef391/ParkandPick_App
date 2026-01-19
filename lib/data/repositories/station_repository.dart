import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testtt/core/failure.dart';
import 'package:testtt/data/models/station_model.dart';

/// Station Repository - Handles station data and pickup operations
abstract class StationRepository {
  Future<Either<Failure, List<Station>>> fetchStations();
  Future<Either<Failure, List<Station>>> loadStationsWithLocation(
      double userLat, double userLng);
  Future<Either<Failure, bool>> confirmPickup(String orderId, Station station);
}

@LazySingleton(as: StationRepository)
class StationRepositoryImpl implements StationRepository {
  // Static stations removed to enforce Supabase usage

  @override
  Future<Either<Failure, List<Station>>> fetchStations() async {
    try {
      print('DEBUG: Fetching stations from Supabase...');
      final response = await Supabase.instance.client
          .from('stations')
          .select()
          .order('name', ascending: true);

      final List<dynamic> data = response as List<dynamic>;
      final stations = data.map((json) => Station.fromSupabase(json)).toList();

      return Right(stations);
    } catch (e) {
      return Left(ServerFailure('Unable to load stations: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<Station>>> loadStationsWithLocation(
    double userLat,
    double userLng,
  ) async {
    try {
      final result = await fetchStations();

      return result.fold((failure) => Left(failure), (stations) {
        final stationsWithDistance = stations.map((station) {
          final distance = Geolocator.distanceBetween(
            userLat,
            userLng,
            station.latitude,
            station.longitude,
          ).round();

          final etaMinutes = (distance / 1000 * 12).round().clamp(1, 999);

          return station.copyWith(
            distanceMeters: distance,
            etaMinutes: etaMinutes,
            // Update status based on logic if needed
          );
        }).toList();

        stationsWithDistance
            .sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

        return Right(stationsWithDistance);
      });
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> confirmPickup(
      String orderId, Station station) async {
    try {
      if (!station.isOpen) {
        return const Left(
            ServerFailure('Selected station is currently closed'));
      }

      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 1500));
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure('Unable to confirm pickup. Please try again.'));
    }
  }
}
