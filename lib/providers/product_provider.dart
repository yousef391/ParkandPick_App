import 'package:flutter/material.dart';
import 'package:testtt/data/models/product_model.dart';

/// Product Provider - State Management for Products
/// Responsibilities:
/// - Fetch and manage products list
/// - Handle loading, error, and success states
/// - Provide filtered products by category
/// - Handle product search
/// - Manage individual product details
class ProductProvider extends ChangeNotifier {
  // Private state
  List<Product> _products = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<Product> get products => _products;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get hasProducts => _products.isNotEmpty;

  /// Initialize and fetch all products
  Future<void> initialize() async {
    await fetchProducts();
  }

  /// Fetch all products from API
  Future<void> fetchProducts() async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Replace with actual API call when backend is ready
      // Example:
      // final response = await http.get(Uri.parse('YOUR_API_URL/products'));
      // if (response.statusCode == 200) {
      //   final List data = jsonDecode(response.body);
      //   _products = data.map((json) => Product.fromJson(json)).toList();
      // } else {
      //   throw Exception('Failed to load products');
      // }

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 1000));

      // Use centralized mock data from ProductExamples
      _products = ProductExamples.getAllProducts();

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load products. Please check your connection.');
      _setLoading(false);
      debugPrint('Error fetching products: $e');
    }
  }

  /// Fetch products by category from API
  Future<void> fetchProductsByCategory(String category) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Replace with actual API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/products?category=$category'),
      // );

      await Future.delayed(const Duration(milliseconds: 800));

      // Use centralized mock data
      _products = ProductExamples.getProductsByCategory(category);

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load products by category.');
      _setLoading(false);
      debugPrint('Error fetching products by category: $e');
    }
  }

  /// Get products by category (client-side filtering)
  List<Product> getProductsByCategory(String category) {
    if (category == 'all') return _products;
    return _products.where((p) => p.category == category).toList();
  }

  /// Search products by name or description (client-side)
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return _products;

    final queryLower = query.toLowerCase();
    return _products.where((product) {
      final nameLower = product.name.toLowerCase();
      final descLower = product.description.toLowerCase();
      return nameLower.contains(queryLower) || descLower.contains(queryLower);
    }).toList();
  }

  /// Get product by ID
  Product? getProductById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (e) {
      debugPrint('Product not found: $id');
      return null;
    }
  }

  /// Fetch single product details by ID
  Future<Product?> fetchProductById(String id) async {
    _setLoading(true);
    _clearError();

    try {
      // TODO: Replace with actual API call
      // final response = await http.get(
      //   Uri.parse('YOUR_API_URL/products/$id'),
      // );
      // _selectedProduct = Product.fromJson(jsonDecode(response.body));

      await Future.delayed(const Duration(milliseconds: 500));

      _selectedProduct = getProductById(id);

      if (_selectedProduct == null) {
        throw Exception('Product not found');
      }

      _setLoading(false);
      return _selectedProduct;
    } catch (e) {
      _setError('Failed to load product details.');
      _setLoading(false);
      debugPrint('Error fetching product by ID: $e');
      return null;
    }
  }

  /// Set selected product (for navigation to detail screen)
  void selectProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  /// Clear selected product
  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }

  /// Refresh products (pull-to-refresh)
  Future<void> refresh() async {
    await fetchProducts();
  }

  /// Retry loading products (on error)
  Future<void> retry() async {
    await fetchProducts();
  }

  /// Filter products by availability
  List<Product> getAvailableProducts() {
    return _products.where((p) => p.isAvailable).toList();
  }

  /// Get products count by category
  Map<String, int> getProductCountByCategory() {
    final Map<String, int> counts = {
      'all': _products.length,
      'cup': 0,
      'beans': 0,
      'ground': 0,
      'specials': 0,
    };

    for (var product in _products) {
      counts[product.category] = (counts[product.category] ?? 0) + 1;
    }

    return counts;
  }

  /// Check if category has products
  bool hasCategoryProducts(String category) {
    if (category == 'all') return _products.isNotEmpty;
    return _products.any((p) => p.category == category);
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  /// Clear error message manually
  void clearError() {
    _clearError();
    notifyListeners();
  }

  /// Reset provider state (for logout, etc.)
  void reset() {
    _products = [];
    _selectedProduct = null;
    _isLoading = false;
    _errorMessage = null;
    notifyListeners();
  }

  /// Dispose method (optional - for cleanup if needed)
  @override
  void dispose() {
    _products.clear();
    super.dispose();
  }
}

// ============================================================================
// PRODUCT REPOSITORY INTERFACE (Clean Architecture - Optional)
// ============================================================================

/// Product Repository Interface
/// Use this when you implement actual API calls
/// Follows Repository Pattern and Dependency Inversion Principle
abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<List<Product>> fetchProductsByCategory(String category);
  Future<Product> fetchProductById(String id);
  Future<List<Product>> searchProducts(String query);
}

// ============================================================================
// PRODUCT REPOSITORY IMPLEMENTATION (For Future API Integration)
// ============================================================================

/// Product Repository Implementation
/// Implement this when your backend is ready
class ProductRepositoryImpl implements ProductRepository {
  // final ApiService _apiService;
  // final String baseUrl = 'YOUR_API_BASE_URL';

  // ProductRepositoryImpl({required ApiService apiService})
  //     : _apiService = apiService;

  @override
  Future<List<Product>> fetchProducts() async {
    try {
      // TODO: Implement actual API call
      // final response = await http.get(Uri.parse('$baseUrl/products'));
      // if (response.statusCode == 200) {
      //   final List data = jsonDecode(response.body);
      //   return data.map((json) => Product.fromJson(json)).toList();
      // }
      // throw RepositoryException('Failed to load products');

      throw UnimplementedException();
    } catch (e) {
      throw RepositoryException('Failed to fetch products: $e');
    }
  }

  @override
  Future<List<Product>> fetchProductsByCategory(String category) async {
    try {
      // TODO: Implement actual API call
      // final response = await http.get(
      //   Uri.parse('$baseUrl/products?category=$category'),
      // );

      throw UnimplementedException();
    } catch (e) {
      throw RepositoryException('Failed to fetch products by category: $e');
    }
  }

  @override
  Future<Product> fetchProductById(String id) async {
    try {
      // TODO: Implement actual API call
      // final response = await http.get(Uri.parse('$baseUrl/products/$id'));

      throw UnimplementedException();
    } catch (e) {
      throw RepositoryException('Failed to fetch product: $e');
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    try {
      // TODO: Implement actual API call
      // final response = await http.get(
      //   Uri.parse('$baseUrl/products/search?q=$query'),
      // );

      throw UnimplementedException();
    } catch (e) {
      throw RepositoryException('Failed to search products: $e');
    }
  }
}

// ============================================================================
// CUSTOM EXCEPTIONS
// ============================================================================

class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => message;
}

class UnimplementedException implements Exception {
  @override
  String toString() =>
      'This feature is not yet implemented. API integration pending.';
}
