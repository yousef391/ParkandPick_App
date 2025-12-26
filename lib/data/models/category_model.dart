/// Category Model - Immutable Domain Entity
/// Represents product categories in the ParkAndPick app
class CategoryModel {
  final String id;
  final String label;
  final String? icon; // Optional icon identifier
  final int? productCount; // Optional: number of products in category

  const CategoryModel({
    required this.id,
    required this.label,
    this.icon,
    this.productCount,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon': icon,
      'productCount': productCount,
    };
  }

  /// Restore from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      label: json['label'] as String,
      icon: json['icon'] as String?,
      productCount: json['productCount'] as int?,
    );
  }

  /// Copy with updated values
  CategoryModel copyWith({
    String? id,
    String? label,
    String? icon,
    int? productCount,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      productCount: productCount ?? this.productCount,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
