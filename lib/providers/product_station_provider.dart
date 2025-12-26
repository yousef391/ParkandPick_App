import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:testtt/data/models/station_model.dart';

class ProductStationProvider extends ChangeNotifier {
  List<Station> _stations = [];
  List<Station> _nearbyStations = [];
  Station? _selectedStation;
  bool _loading = false;
  String? _error;
  bool _confirming = false;

  List<Station> get stations => _stations;
  List<Station> get nearbyStations => _nearbyStations;
  Station? get selectedStation => _selectedStation;
  bool get isLoading => _loading;
  String? get errorMessage => _error;
  bool get isConfirming => _confirming;

  /// Load mock stations (DEMO ONLY - Remove when API is ready)
  void loadMockStations() {
    _loading = true;
    notifyListeners();

    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 800), () {
      _stations = staticStations;

      _loading = false;
      _error = null;
      notifyListeners();
    });
  }

  /// Static stations data - Real coordinates
  static List<Station> get staticStations => [
        Station(
          id: '1',
          name: 'Downtown Toronto',
          latitude: 43.6532,
          longitude: -79.3832,
          address: '100 Queen St W, Toronto, ON',
          distanceMeters: 0,
          etaMinutes: 0,
          isOpen: true,
          capacityInfo: '3/5 available',
        ),
        Station(
          id: '2',
          name: 'Montreal Central',
          latitude: 45.5017,
          longitude: -73.5673,
          address: '450 Rue Sainte-Catherine O, Montréal, QC',
          distanceMeters: 0,
          etaMinutes: 0,
          isOpen: true,
          capacityInfo: '5/6 available',
        ),
        Station(
          id: '3',
          name: 'Vancouver Harbour',
          latitude: 49.2827,
          longitude: -123.1207,
          address: '999 Canada Pl, Vancouver, BC',
          distanceMeters: 0,
          etaMinutes: 0,
          isOpen: false,
          capacityInfo: 'Closed',
        ),
        Station(
          id: '4',
          name: 'Calgary Beltline',
          latitude: 51.0447,
          longitude: -114.0719,
          address: '12 Ave SW, Calgary, AB',
          distanceMeters: 0,
          etaMinutes: 0,
          isOpen: true,
          capacityInfo: '2/5 available',
        ),
      ];

  /// Load stations and calculate real distances from user location
  Future<void> loadStationsWithLocation(double userLat, double userLng) async {
    _loading = true;
    notifyListeners();

    // Calculate real distance for each station from user's current location
    final stationsWithDistance = staticStations.map((station) {
      // Calculate real distance using Geolocator (Haversine formula)
      final distance = Geolocator.distanceBetween(
        userLat,
        userLng,
        station.latitude,
        station.longitude,
      ).round();

      // Estimate walking ETA: ~12 min per km (5 km/h walking speed)
      final etaMinutes = (distance / 1000 * 12).round().clamp(1, 999);

      return station.copyWith(
        distanceMeters: distance,
        etaMinutes: etaMinutes,
      );
    }).toList();

    // Sort by distance (nearest first)
    stationsWithDistance
        .sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

    // Update both lists with real distances
    _stations = stationsWithDistance;
    _nearbyStations = stationsWithDistance;

    _loading = false;
    _error = null;
    notifyListeners();
  }

  /// Fetch stations from API (implement when backend is ready)
  Future<void> fetchStations() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      // final response = await http.get(Uri.parse('YOUR_API_URL/stations'));
      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   _stations = (data as List).map((json) => Station.fromJson(json)).toList();
      // }

      await Future.delayed(const Duration(seconds: 1)); // Mock delay

      _loading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Unable to load stations. Please check your connection.';
      _loading = false;
      notifyListeners();
    }
  }

  /// Select a station by ID
  void selectStation(String stationId) {
    try {
      _selectedStation = _stations.firstWhere(
        (station) => station.id == stationId,
      );
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Station not found';
      notifyListeners();
    }
  }

  /// Deselect current station
  void deselectStation() {
    _selectedStation = null;
    notifyListeners();
  }

  /// Confirm pickup at selected station
  Future<bool> confirmPickup(String orderId) async {
    if (_selectedStation == null) {
      _error = 'Please select a pickup station';
      notifyListeners();
      return false;
    }

    if (!_selectedStation!.isOpen) {
      _error = 'Selected station is currently closed';
      notifyListeners();
      return false;
    }

    _confirming = true;
    _error = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      // final response = await http.post(
      //   Uri.parse('YOUR_API_URL/orders/$orderId/confirm-pickup'),
      //   body: jsonEncode({
      //     'stationId': _selectedStation!.id,
      //     'stationName': _selectedStation!.name,
      //   }),
      // );

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Mock success
      _confirming = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Unable to confirm pickup. Please try again.';
      _confirming = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear error message
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Retry loading stations
  Future<void> retry() async {
    await fetchStations();
  }

  /// Reset provider state (for logout, etc.)
  void reset() {
    _stations = [];
    _selectedStation = null;
    _loading = false;
    _error = null;
    _confirming = false;
    notifyListeners();
  }
}
