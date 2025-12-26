/// Product Extra/Addon Model - Immutable Domain Entity
/// Represents add-ons/extras for coffee products (milk, sweeteners, syrups, etc.)
class ProductExtra {
  final String id;
  final String name;
  final double price;
  final ExtraType type;
  final String icon; // Emoji or icon identifier
  final bool isAvailable;

  const ProductExtra({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.icon,
    this.isAvailable = true,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'type': type.name,
      'icon': icon,
      'isAvailable': isAvailable,
    };
  }

  /// Restore from JSON
  factory ProductExtra.fromJson(Map<String, dynamic> json) {
    return ProductExtra(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      type: ExtraType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ExtraType.other,
      ),
      icon: json['icon'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  /// Copy with updated values
  ProductExtra copyWith({
    String? id,
    String? name,
    double? price,
    ExtraType? type,
    String? icon,
    bool? isAvailable,
  }) {
    return ProductExtra(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductExtra && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Extra Type Enum
enum ExtraType { coffee, milk, sweetener, syrup, topping, other }
