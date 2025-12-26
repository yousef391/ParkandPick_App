import 'package:flutter_test/flutter_test.dart';
import 'package:testtt/data/models/product_model.dart';
import 'package:testtt/providers/favorites_provider.dart';

void main() {
  group('FavoritesProvider', () {
    late FavoritesProvider provider;
    final sample = Product(
      id: '1',
      name: 'Test Coffee',
      description: 'Tasty',
      price: 10.0,
      imageUrl: 'assets/images/nathan-dumlao-dAYJfrtVjh0-unsplash.jpg',
      category: 'cup',
    );

    setUp(() {
      provider = FavoritesProvider();
    });

    test('toggleFavorite adds and removes', () {
      expect(provider.isFavorite(sample.id), false);
      provider.toggleFavorite(sample);
      expect(provider.isFavorite(sample.id), true);
      provider.toggleFavorite(sample);
      expect(provider.isFavorite(sample.id), false);
    });

    test('addFavorite does not duplicate', () {
      provider.addFavorite(sample);
      provider.addFavorite(sample);
      expect(provider.favorites.length, 1);
    });

    test('removeFavorite removes item', () {
      provider.addFavorite(sample);
      provider.removeFavorite(sample.id);
      expect(provider.isEmpty, true);
    });
  });
}

