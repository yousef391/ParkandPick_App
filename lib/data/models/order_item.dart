class OrderItem {
  final String id;
  final String name;
  final String size;
  final double price;
  final String imagePath;
  final int quantity;
  final List<String> addons;

  OrderItem({
    required this.id,
    required this.name,
    required this.size,
    required this.price,
    required this.imagePath,
    this.quantity = 1,
    this.addons = const [],
  });

  /// Total price for this item (without addon costs)
  double get totalPrice => price * quantity;

  /// Convert to JSON for API or local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'size': size,
      'price': price,
      'imagePath': imagePath,
      'quantity': quantity,
      'addons': addons,
    };
  }

  /// Restore from JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      name: json['name'] as String,
      size: json['size'] as String,
      price: (json['price'] as num).toDouble(),
      imagePath: json['imagePath'] as String,
      quantity: json['quantity'] as int? ?? 1,
      addons: List<String>.from(json['addons'] ?? []),
    );
  }

  /// Copy with updated values
  OrderItem copyWith({
    String? id,
    String? name,
    String? size,
    double? price,
    String? imagePath,
    int? quantity,
    List<String>? addons,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      price: price ?? this.price,
      imagePath: imagePath ?? this.imagePath,
      quantity: quantity ?? this.quantity,
      addons: addons ?? this.addons,
    );
  }
}
