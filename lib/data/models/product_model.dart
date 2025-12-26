/// Product Model - Immutable Domain Entity
/// Represents a coffee product in the ParkAndPick app
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category; // 'cup', 'beans', 'ground', 'specials'
  final bool isAvailable;
  final List<String>? availableSizes; // Optional: ['S', 'M', 'L']
  final List<String>? tags; // Optional: ['popular', 'new', 'limited']

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    this.isAvailable = true,
    this.availableSizes,
    this.tags,
  });

  /// Convert to JSON for API or local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
      'availableSizes': availableSizes,
      'tags': tags,
    };
  }

  /// Restore from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      availableSizes: json['availableSizes'] != null
          ? List<String>.from(json['availableSizes'])
          : null,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  /// Copy with updated values
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    bool? isAvailable,
    List<String>? availableSizes,
    List<String>? tags,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      availableSizes: availableSizes ?? this.availableSizes,
      tags: tags ?? this.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// ============================================================================
// MOCK DATA - ProductExamples
// ============================================================================

/// Centralized mock data for products
/// Used for development and testing until API is ready
class ProductExamples {
  static List<Product> getAllProducts() {
    return [
      // Cup Category
      Product(
        id: '1',
        name: 'Espresso',
        description: 'Rich and bold Italian espresso',
        price: 250.0,
        imageUrl: 'assets/images/nathan-dumlao-dAYJfrtVjh0-unsplash.jpg',
        category: 'cup',
        isAvailable: true,
        availableSizes: ['S', 'M', 'L'],
        tags: ['popular'],
      ),
      Product(
        id: '2',
        name: 'Cappuccino',
        description: 'Espresso with steamed milk foam',
        price: 300.0,
        imageUrl: 'assets/images/joao-mansano-MTHx-34eKZw-unsplash.jpg',
        category: 'cup',
        isAvailable: true,
        availableSizes: ['M', 'L'],
        tags: ['popular', 'new'],
      ),
      Product(
        id: '3',
        name: 'Latte',
        description: 'Smooth espresso with steamed milk',
        price: 320.0,
        imageUrl: 'assets/images/mahyar-motebassem-fOC5X_i-Ri8-unsplash.jpg',
        category: 'cup',
        isAvailable: true,
        availableSizes: ['M', 'L'],
      ),
      Product(
        id: '4',
        name: 'Americano',
        description: 'Espresso with hot water',
        price: 280.0,
        imageUrl: 'assets/images/an-nguyen-MHWbEt0VfEY-unsplash.jpg',
        category: 'cup',
        isAvailable: true,
        availableSizes: ['S', 'M', 'L'],
      ),
      Product(
        id: '5',
        name: 'Mocha',
        description: 'Chocolate espresso with steamed milk',
        price: 350.0,
        imageUrl: 'assets/images/jahanzeb-ahsan-uyqGLLgC-GE-unsplash.jpg',
        category: 'cup',
        isAvailable: true,
        availableSizes: ['M', 'L'],
        tags: ['popular'],
      ),
      Product(
        id: '6',
        name: 'Macchiato',
        description: 'Espresso with a dollop of foam',
        price: 290.0,
        imageUrl: 'assets/images/nuril-ahsan-fOpxfHDX3Ek-unsplash.jpg',
        category: 'cup',
        isAvailable: false,
        availableSizes: ['S', 'M'],
      ),

      // Beans Category
      Product(
        id: '7',
        name: 'Arabica Beans',
        description: 'Premium Arabica coffee beans',
        price: 1200.0,
        imageUrl: 'assets/images/nathan-dumlao-dAYJfrtVjh0-unsplash.jpg',
        category: 'beans',
        isAvailable: true,
        tags: ['popular'],
      ),
      Product(
        id: '8',
        name: 'Robusta Beans',
        description: 'Strong Robusta coffee beans',
        price: 1000.0,
        imageUrl: 'assets/images/joao-mansano-MTHx-34eKZw-unsplash.jpg',
        category: 'beans',
        isAvailable: true,
      ),
      Product(
        id: '9',
        name: 'Ethiopian Yirgacheffe',
        description: 'Single origin Ethiopian beans',
        price: 1500.0,
        imageUrl: 'assets/images/mahyar-motebassem-fOC5X_i-Ri8-unsplash.jpg',
        category: 'beans',
        isAvailable: true,
        tags: ['new', 'limited'],
      ),

      // Ground Category
      Product(
        id: '10',
        name: 'Medium Roast Ground',
        description: 'Perfectly ground medium roast coffee',
        price: 800.0,
        imageUrl: 'assets/images/an-nguyen-MHWbEt0VfEY-unsplash.jpg',
        category: 'ground',
        isAvailable: true,
      ),
      Product(
        id: '11',
        name: 'Dark Roast Ground',
        description: 'Bold dark roast ground coffee',
        price: 850.0,
        imageUrl: 'assets/images/jahanzeb-ahsan-uyqGLLgC-GE-unsplash.jpg',
        category: 'ground',
        isAvailable: true,
        tags: ['popular'],
      ),
      Product(
        id: '12',
        name: 'Light Roast Ground',
        description: 'Smooth light roast ground coffee',
        price: 750.0,
        imageUrl: 'assets/images/nuril-ahsan-fOpxfHDX3Ek-unsplash.jpg',
        category: 'ground',
        isAvailable: true,
      ),

      // Specials Category
      Product(
        id: '13',
        name: 'Caramel Macchiato',
        description: 'Special caramel-flavored macchiato',
        price: 380.0,
        imageUrl: 'assets/images/nathan-dumlao-dAYJfrtVjh0-unsplash.jpg',
        category: 'specials',
        isAvailable: true,
        availableSizes: ['M', 'L'],
        tags: ['popular', 'new'],
      ),
      Product(
        id: '14',
        name: 'Vanilla Latte',
        description: 'Creamy vanilla latte',
        price: 360.0,
        imageUrl: 'assets/images/joao-mansano-MTHx-34eKZw-unsplash.jpg',
        category: 'specials',
        isAvailable: true,
        availableSizes: ['M', 'L'],
        tags: ['popular'],
      ),
      Product(
        id: '15',
        name: 'Hazelnut Cappuccino',
        description: 'Rich hazelnut cappuccino',
        price: 370.0,
        imageUrl: 'assets/images/mahyar-motebassem-fOC5X_i-Ri8-unsplash.jpg',
        category: 'specials',
        isAvailable: true,
        availableSizes: ['M', 'L'],
      ),
    ];
  }

  static List<Product> getProductsByCategory(String category) {
    if (category == 'all') return getAllProducts();
    return getAllProducts().where((p) => p.category == category).toList();
  }

  static Product? getProductById(String id) {
    try {
      return getAllProducts().firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
