/// Product Model - Immutable Domain Entity
/// Represents a coffee product in the ParkAndPick app
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category; // 'cup', 'beans', 'ground', 'specials', 'café'
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

  /// Create from Supabase JSON (snake_case)
  factory Product.fromSupabase(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String? ?? 'assets/images/default.png',
      category: json['category'] as String,
      isAvailable: json['is_available'] as bool? ?? true,
      availableSizes: json['available_sizes'] != null
          ? List<String>.from(json['available_sizes'])
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
      // ===== CAFÉ =====
      Product(
        id: '1',
        name: 'Petit Café filtre du jour',
        description: 'Freshly brewed daily filter coffee',
        price: 2.5,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
        tags: ['new', 'popular', 'promo'],
      ),
      Product(
        id: '2',
        name: 'Grand Café filtre du jour',
        description: 'Large daily filter coffee',
        price: 3.0,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
      ),
      Product(
        id: '3',
        name: 'Espresso',
        description: 'Strong and intense espresso',
        price: 2.5,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
        tags: ['popular'],
      ),
      Product(
        id: '4',
        name: 'Petit Americano',
        description: 'Espresso with hot water',
        price: 3.0,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
      ),
      Product(
        id: '5',
        name: 'Grand Americano',
        description: 'Large espresso with hot water',
        price: 3.5,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
      ),
      Product(
        id: '6',
        name: 'Petit Cappuccino ou Latte classique',
        description: 'Espresso with steamed milk',
        price: 3.75,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
      ),
      Product(
        id: '7',
        name: 'Grand Cappuccino ou Latte classique',
        description: 'Large espresso with steamed milk',
        price: 4.5,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
      ),
      Product(
        id: '8',
        name: 'Cold Brew (P& Essentials)',
        description: 'Smooth cold brewed coffee',
        price: 4.25,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
      ),
      Product(
        id: '9',
        name: 'Café des Mille Collines',
        description: 'Premium Rwandan coffee',
        price: 4.5,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
      ),
      Product(
        id: '10',
        name: 'Iced Latte',
        description: 'Cold latte with ice',
        price: 4.25,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
      ),
      Product(
        id: '11',
        name: 'Latte au lait d’avoine',
        description: 'Oat milk latte (vegan)',
        price: 4.75,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
        tags: ['vegan'],
      ),
      Product(
        id: '12',
        name: 'Chai Latte ou Matcha Latte',
        description: 'Spiced chai or matcha latte',
        price: 4.5,
        imageUrl: 'assets/images/default.png',
        category: 'cafe',
        isAvailable: true,
      ),

      // ===== BOISSONS =====
      Product(
        id: '13',
        name: 'Jus pressé carotte-orange-gingembre',
        description: 'Fresh pressed juice',
        price: 4.25,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '14',
        name: 'Jus pressé pomme-betterave',
        description: 'Fresh apple & beet juice',
        price: 4.25,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '15',
        name: 'Limonade maison citron-menthe',
        description: 'Homemade lemonade',
        price: 3.95,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '16',
        name: 'Limonade maison hibiscus glacé',
        description: 'Iced hibiscus lemonade',
        price: 3.95,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '17',
        name: 'Limonade maison goyave',
        description: 'Guava homemade lemonade',
        price: 3.95,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '18',
        name: 'Frappé glacé moka',
        description: 'Iced mocha frappé',
        price: 5.25,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '19',
        name: 'Frappé glacé matcha',
        description: 'Iced matcha frappé',
        price: 5.25,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '20',
        name: 'Frappé glacé coco',
        description: 'Coconut iced frappé',
        price: 5.25,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '21',
        name: 'Milkshake vanille passion',
        description: 'Vanilla passion milkshake',
        price: 6.5,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '22',
        name: 'Milkshake pink banana',
        description: 'Banana flavored milkshake',
        price: 6.5,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '23',
        name: 'Milkshake Kigali choco-café',
        description: 'Chocolate coffee milkshake',
        price: 6.5,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '24',
        name: 'Smoothie Strike Kivu Kick',
        description: 'Energy boosting smoothie',
        price: 5.75,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '25',
        name: 'Smoothie Strike Baie du Nord',
        description: 'Berry smoothie',
        price: 5.75,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),
      Product(
        id: '26',
        name: 'Smoothie Strike Vert Vitalité',
        description: 'Green vitality smoothie',
        price: 5.75,
        imageUrl: 'assets/images/default.png',
        category: 'boissons',
        isAvailable: true,
      ),

      // ===== BOÎTE LUNCH =====
      Product(
        id: '27',
        name: 'Ma Boîte École',
        description: 'Fresh school lunch box',
        price: 9.0,
        imageUrl: 'assets/images/default.png',
        category: 'lunch',
        isAvailable: true,
      ),
      Product(
        id: '28',
        name: 'Pause Pro',
        description: 'Professional lunch box',
        price: 12.5,
        imageUrl: 'assets/images/default.png',
        category: 'lunch',
        isAvailable: true,
      ),
      Product(
        id: '29',
        name: 'Ma Verte',
        description: 'Vegetarian & vegan lunch box',
        price: 11.5,
        imageUrl: 'assets/images/default.png',
        category: 'lunch',
        isAvailable: true,
        tags: ['vegan', 'vegetarian'],
      ),

      // ===== SNACKS =====
      Product(
        id: '30',
        name: 'Muffins maison',
        description: 'Homemade muffins',
        price: 6.0,
        imageUrl: 'assets/images/default.png',
        category: 'snacks',
        isAvailable: true,
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
