import 'package:testtt/data/models/order_item.dart';

/// Order Status Enum
enum OrderStatus {
  pending,
  preparing,
  ready,
  completed,
  cancelled,
}

/// Order Model - Represents a complete order
class Order {
  final String id;
  final List<OrderItem> items;
  final String stationId;
  final String stationName;
  final String stationAddress;
  final double totalPrice;
  final DateTime createdAt;
  final OrderStatus status;
  final int? estimatedMinutes;

  Order({
    required this.id,
    required this.items,
    required this.stationId,
    required this.stationName,
    required this.stationAddress,
    required this.totalPrice,
    required this.createdAt,
    this.status = OrderStatus.pending,
    this.estimatedMinutes,
  });

  /// Number of items in order
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get status display text
  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'En attente';
      case OrderStatus.preparing:
        return 'En préparation';
      case OrderStatus.ready:
        return 'Prêt à récupérer';
      case OrderStatus.completed:
        return 'Complété';
      case OrderStatus.cancelled:
        return 'Annulé';
    }
  }

  /// Get order summary text (e.g., "2 articles • $15.99")
  String get summaryText {
    final itemText = itemCount == 1 ? '1 article' : '$itemCount articles';
    return itemText;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'stationId': stationId,
      'stationName': stationName,
      'stationAddress': stationAddress,
      'totalPrice': totalPrice,
      'createdAt': createdAt.toIso8601String(),
      'status': status.index,
      'estimatedMinutes': estimatedMinutes,
    };
  }

  /// Restore from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      stationId: json['stationId'] as String,
      stationName: json['stationName'] as String,
      stationAddress: json['stationAddress'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: OrderStatus.values[json['status'] as int? ?? 0],
      estimatedMinutes: json['estimatedMinutes'] as int?,
    );
  }

  /// Create from Supabase DB (snake_case)
  factory Order.fromSupabase(Map<String, dynamic> json) {
    final itemsJson = json['order_items'] as List<dynamic>? ?? [];
    final items =
        itemsJson.map((item) => OrderItem.fromSupabase(item)).toList();

    return Order(
      id: json['id'] as String,
      items: items,
      stationId: json['station_id'] as String,
      // Handle joined station data or fallback to empty string/ID if missing
      stationName: json['stations']?['name'] as String? ?? 'Unknown Station',
      stationAddress: json['stations']?['address'] as String? ?? '',
      totalPrice: (json['total_price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      estimatedMinutes: json['estimated_minutes'],
    );
  }

  /// Create payload for Supabase insertion
  static Map<String, dynamic> createSupabasePayload({
    required String userId,
    required String stationId,
    required String stationName,
    required String stationAddress,
    required double totalPrice,
    required int estimatedMinutes,
  }) {
    return {
      'user_id': userId,
      'station_id': stationId,
      // 'station_name': stationName, // Not in DB schema
      // 'station_address': stationAddress, // Not in DB schema
      'total_price': totalPrice,
      'status': 'pending',
      'estimated_minutes': estimatedMinutes,
    };
  }

  /// Copy with updated values
  Order copyWith({
    String? id,
    List<OrderItem>? items,
    String? stationId,
    String? stationName,
    String? stationAddress,
    double? totalPrice,
    DateTime? createdAt,
    OrderStatus? status,
    int? estimatedMinutes,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      stationId: stationId ?? this.stationId,
      stationName: stationName ?? this.stationName,
      stationAddress: stationAddress ?? this.stationAddress,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
    );
  }
}
