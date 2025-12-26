import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Location Provider - Manages user's current location
class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  bool _isLoading = false;
  String? _error;
  bool _permissionDenied = false;

  Position? get currentPosition => _currentPosition;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasLocation => _currentPosition != null;
  bool get permissionDenied => _permissionDenied;

  double? get latitude => _currentPosition?.latitude;
  double? get longitude => _currentPosition?.longitude;

  /// Get current location with permission handling
  Future<bool> getCurrentLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('///////////////////////////////////////////////////////////////');
      print('Location services enabled: $serviceEnabled');
      if (!serviceEnabled) {
        _error = 'Les services de localisation sont désactivés';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _error = 'Permission de localisation refusée';
          _permissionDenied = true;
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _error = 'Permission de localisation refusée définitivement';
        _permissionDenied = true;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );

      _permissionDenied = false;
      _error = null;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Erreur de localisation: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Calculate distance between user and a point (in meters)
  double? distanceTo(double lat, double lng) {
    if (_currentPosition == null) return null;
    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      lat,
      lng,
    );
  }

  /// Open app settings for location permission
  Future<bool> openSettings() async {
    return await Geolocator.openAppSettings();
  }
}
