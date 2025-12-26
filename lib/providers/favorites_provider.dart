import 'package:flutter/material.dart';
import 'package:testtt/data/models/product_model.dart';

/// Favorites Provider - manages user's favorite products
class FavoritesProvider extends ChangeNotifier {
  final List<Product> _favorites = [];
  bool _isLoading = false;

  List<Product> get favorites => List.unmodifiable(_favorites);
  bool get isLoading => _isLoading;
  bool get isEmpty => _favorites.isEmpty;

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    // TODO: Replace with persistence (local/remote)
    await Future.delayed(const Duration(milliseconds: 200));
    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  void addFavorite(Product product) {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
      notifyListeners();
    }
  }

  void removeFavorite(String productId) {
    _favorites.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  void clear() {
    _favorites.clear();
    notifyListeners();
  }
}
