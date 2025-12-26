import 'package:flutter_test/flutter_test.dart';
import 'package:testtt/providers/products_details_provider.dart';

void main() {
  group('ProductDetailsProvider Tests', () {
    late ProductDetailsProvider provider;

    setUp(() {
      provider = ProductDetailsProvider();
    });

    test('should initialize with default values', () {
      expect(provider.selectedSized, 'M');
      expect(provider.quantity, 1);
      expect(provider.selectedAddons, isEmpty);
      expect(provider.isFavorite, false);
      expect(provider.isDescriptionExpanded, false);
    });

    test('setSelectedSize should update size', () {
      provider.setSelectedSize('L');
      expect(provider.selectedSized, 'L');

      provider.setSelectedSize('S');
      expect(provider.selectedSized, 'S');
    });

    test('incrementQuantity should increase quantity', () {
      expect(provider.quantity, 1);

      provider.incrementQuantity();
      expect(provider.quantity, 2);

      provider.incrementQuantity();
      expect(provider.quantity, 3);
    });

    test('decrementQuantity should decrease quantity', () {
      provider.setQuantity(5);
      expect(provider.quantity, 5);

      provider.decrementQuantity();
      expect(provider.quantity, 4);

      provider.decrementQuantity();
      expect(provider.quantity, 3);
    });

    test('decrementQuantity should not go below 1', () {
      expect(provider.quantity, 1);

      provider.decrementQuantity();
      expect(provider.quantity, 1); // Should stay at 1

      provider.decrementQuantity();
      expect(provider.quantity, 1); // Should stay at 1
    });

    test('setQuantity should update quantity', () {
      provider.setQuantity(10);
      expect(provider.quantity, 10);

      provider.setQuantity(1);
      expect(provider.quantity, 1);
    });

    test('setQuantity should not allow values less than 1', () {
      provider.setQuantity(5);
      expect(provider.quantity, 5);

      provider.setQuantity(0);
      expect(provider.quantity, 5); // Should remain unchanged

      provider.setQuantity(-3);
      expect(provider.quantity, 5); // Should remain unchanged
    });

    test('toggleAddon should add addon when not present', () {
      expect(provider.selectedAddons, isEmpty);

      provider.toggleAddon('Extra Shot');
      expect(provider.selectedAddons, contains('Extra Shot'));
      expect(provider.selectedAddons.length, 1);
    });

    test('toggleAddon should remove addon when already present', () {
      provider.toggleAddon('Vanilla Syrup');
      expect(provider.selectedAddons, contains('Vanilla Syrup'));

      provider.toggleAddon('Vanilla Syrup');
      expect(provider.selectedAddons, isNot(contains('Vanilla Syrup')));
      expect(provider.selectedAddons, isEmpty);
    });

    test('toggleAddon should handle multiple addons', () {
      provider.toggleAddon('Extra Shot');
      provider.toggleAddon('Vanilla Syrup');
      provider.toggleAddon('Whipped Cream');

      expect(provider.selectedAddons.length, 3);
      expect(provider.selectedAddons, contains('Extra Shot'));
      expect(provider.selectedAddons, contains('Vanilla Syrup'));
      expect(provider.selectedAddons, contains('Whipped Cream'));

      provider.toggleAddon('Vanilla Syrup');
      expect(provider.selectedAddons.length, 2);
      expect(provider.selectedAddons, isNot(contains('Vanilla Syrup')));
    });

    test('toggleFavorite should toggle favorite state', () {
      expect(provider.isFavorite, false);

      provider.toggleFavorite();
      expect(provider.isFavorite, true);

      provider.toggleFavorite();
      expect(provider.isFavorite, false);
    });

    test('toggleDescriptionExpanded should toggle description state', () {
      expect(provider.isDescriptionExpanded, false);

      provider.toggleDescriptionExpanded();
      expect(provider.isDescriptionExpanded, true);

      provider.toggleDescriptionExpanded();
      expect(provider.isDescriptionExpanded, false);
    });

    test('resetState should reset all selections to defaults', () {
      // Set non-default values
      provider.setSelectedSize('L');
      provider.setQuantity(5);
      provider.toggleAddon('Extra Shot');
      provider.toggleAddon('Vanilla');
      provider.toggleDescriptionExpanded();

      expect(provider.selectedSized, 'L');
      expect(provider.quantity, 5);
      expect(provider.selectedAddons.length, 2);
      expect(provider.isDescriptionExpanded, true);

      // Reset
      provider.resetState();

      expect(provider.selectedSized, 'M');
      expect(provider.quantity, 1);
      expect(provider.selectedAddons, isEmpty);
      expect(provider.isDescriptionExpanded, false);
      // Note: isFavorite is NOT reset (intentional - favorites persist)
    });

    test('selectedAddons getter should return unmodifiable list', () {
      provider.toggleAddon('Caramel');
      final addons = provider.selectedAddons;

      expect(() => addons.add('Extra Shot'), throwsUnsupportedError);
    });
  });
}
