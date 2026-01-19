/// Station Model - Immutable Domain Entity
/// Represents a pickup station for ParkAndPick orders
class Station {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;
  final int distanceMeters; // convert to km: distanceMeters / 1000
  final int etaMinutes;
  final bool isOpen;
  final String? capacityInfo; // e.g., "3/5 available"

  Station({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.distanceMeters,
    required this.etaMinutes,
    required this.isOpen,
    this.capacityInfo,
  });

  String get distanceKm => (distanceMeters / 1000).toStringAsFixed(1);

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'distanceMeters': distanceMeters,
      'etaMinutes': etaMinutes,
      'isOpen': isOpen,
      'capacityInfo': capacityInfo,
    };
  }

  /// Restore from JSON
  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      distanceMeters: json['distanceMeters'] as int? ?? 0,
      etaMinutes: json['etaMinutes'] as int? ?? 0,
      isOpen: json['isOpen'] as bool? ?? true,
      capacityInfo: json['capacityInfo'] as String?,
    );
  }

  factory Station.fromSupabase(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      distanceMeters: 0, // Calculated locally
      etaMinutes: 15, // Calculated locally or mock
      isOpen: json['is_active'] as bool? ?? true,
      capacityInfo: null,
    );
  }

  /// Copy with updated values
  Station copyWith({
    String? id,
    String? name,
    double? latitude,
    double? longitude,
    String? address,
    int? distanceMeters,
    int? etaMinutes,
    bool? isOpen,
    String? capacityInfo,
  }) {
    return Station(
      id: id ?? this.id,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      etaMinutes: etaMinutes ?? this.etaMinutes,
      isOpen: isOpen ?? this.isOpen,
      capacityInfo: capacityInfo ?? this.capacityInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Station && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
