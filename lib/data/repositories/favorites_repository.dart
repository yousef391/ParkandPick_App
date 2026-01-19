import 'package:injectable/injectable.dart';
import 'package:testtt/data/models/product_model.dart';

/// Favorites Repository - Manages user's favorite products
/// In-memory implementation
@lazySingleton
class FavoritesRepository {
  final List<Product> _favorites = [];

  List<Product> get favorites => List.unmodifiable(_favorites);

  bool get isEmpty => _favorites.isEmpty;

  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.add(product);
    }
  }

  void addFavorite(Product product) {
    if (!isFavorite(product.id)) {
      _favorites.add(product);
    }
  }

  void removeFavorite(String productId) {
    _favorites.removeWhere((p) => p.id == productId);
  }

  void clear() {
    _favorites.clear();
  }
}
