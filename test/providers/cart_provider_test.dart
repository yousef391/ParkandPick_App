import 'package:flutter_test/flutter_test.dart';
import 'package:testtt/data/models/order_item.dart';
import 'package:testtt/providers/cart_provider.dart';

void main() {
  group('CartProvider Tests', () {
    late CartProvider cartProvider;

    setUp(() {
      cartProvider = CartProvider();
    });

    test('should start with empty cart', () {
      expect(cartProvider.items, isEmpty);
      expect(cartProvider.itemCount, 0);
      expect(cartProvider.total, 0.0);
      expect(cartProvider.isEmpty, true);
    });

    test('addToCart should add new item', () {
      final item = OrderItem(
        id: '1',
        name: 'Cappuccino',
        size: 'M',
        price: 250.0,
        imagePath: 'assets/images/cappuccino.png',
        quantity: 2,
      );

      cartProvider.addToCart(item);

      expect(cartProvider.items.length, 1);
      expect(cartProvider.items.first.name, 'Cappuccino');
      expect(cartProvider.items.first.quantity, 2);
      expect(cartProvider.total, 500.0);
    });

    test('addToCart should merge duplicate items by increasing quantity', () {
      final item1 = OrderItem(
        id: '1',
        name: 'Latte',
        size: 'L',
        price: 300.0,
        imagePath: 'assets/images/latte.png',
        quantity: 1,
        addons: ['Vanilla'],
      );

      final item2 = OrderItem(
        id: '1',
        name: 'Latte',
        size: 'L',
        price: 300.0,
        imagePath: 'assets/images/latte.png',
        quantity: 2,
        addons: ['Vanilla'],
      );

      cartProvider.addToCart(item1);
      cartProvider.addToCart(item2);

      expect(cartProvider.items.length, 1);
      expect(cartProvider.items.first.quantity, 3);
      expect(cartProvider.total, 900.0);
    });

    test('addToCart should not merge items with different sizes', () {
      final item1 = OrderItem(
        id: '1',
        name: 'Espresso',
        size: 'S',
        price: 200.0,
        imagePath: 'assets/images/espresso.png',
        quantity: 1,
      );

      final item2 = OrderItem(
        id: '1',
        name: 'Espresso',
        size: 'M',
        price: 200.0,
        imagePath: 'assets/images/espresso.png',
        quantity: 1,
      );

      cartProvider.addToCart(item1);
      cartProvider.addToCart(item2);

      expect(cartProvider.items.length, 2);
    });

    test('addToCart should not merge items with different addons', () {
      final item1 = OrderItem(
        id: '1',
        name: 'Mocha',
        size: 'M',
        price: 280.0,
        imagePath: 'assets/images/mocha.png',
        quantity: 1,
        addons: ['Whipped Cream'],
      );

      final item2 = OrderItem(
        id: '1',
        name: 'Mocha',
        size: 'M',
        price: 280.0,
        imagePath: 'assets/images/mocha.png',
        quantity: 1,
        addons: ['Extra Shot'],
      );

      cartProvider.addToCart(item1);
      cartProvider.addToCart(item2);

      expect(cartProvider.items.length, 2);
    });

    test('removeFromCart should remove item by id and size', () {
      final item1 = OrderItem(
        id: '1',
        name: 'Americano',
        size: 'L',
        price: 220.0,
        imagePath: 'assets/images/americano.png',
      );

      final item2 = OrderItem(
        id: '2',
        name: 'Cappuccino',
        size: 'M',
        price: 250.0,
        imagePath: 'assets/images/cappuccino.png',
      );

      cartProvider.addToCart(item1);
      cartProvider.addToCart(item2);
      expect(cartProvider.items.length, 2);

      cartProvider.removeFromCart('1', 'L');

      expect(cartProvider.items.length, 1);
      expect(cartProvider.items.first.id, '2');
    });

    test('updateQuantity should update item quantity', () {
      final item = OrderItem(
        id: '1',
        name: 'Flat White',
        size: 'M',
        price: 270.0,
        imagePath: 'assets/images/flatwhite.png',
        quantity: 2,
      );

      cartProvider.addToCart(item);
      cartProvider.updateQuantity('1', 5, size: 'M');

      expect(cartProvider.items.first.quantity, 5);
      expect(cartProvider.total, 1350.0);
    });

    test('updateQuantity should remove item when quantity is 0', () {
      final item = OrderItem(
        id: '1',
        name: 'Macchiato',
        size: 'S',
        price: 230.0,
        imagePath: 'assets/images/macchiato.png',
        quantity: 3,
      );

      cartProvider.addToCart(item);
      cartProvider.updateQuantity('1', 0, size: 'S');

      // Item should be removed
      expect(cartProvider.items.length, 0);
    });

    test('updateQuantity should do nothing for non-existent item', () {
      final item = OrderItem(
        id: '1',
        name: 'Latte',
        size: 'M',
        price: 300.0,
        imagePath: 'assets/images/latte.png',
      );

      cartProvider.addToCart(item);
      cartProvider.updateQuantity('999', 10, size: 'M');

      // Original item should be unchanged
      expect(cartProvider.items.first.quantity, 1);
    });

    test('clear should remove all items', () {
      final item1 = OrderItem(
        id: '1',
        name: 'Cappuccino',
        size: 'M',
        price: 250.0,
        imagePath: 'assets/images/cappuccino.png',
      );

      final item2 = OrderItem(
        id: '2',
        name: 'Latte',
        size: 'L',
        price: 300.0,
        imagePath: 'assets/images/latte.png',
      );

      cartProvider.addToCart(item1);
      cartProvider.addToCart(item2);
      expect(cartProvider.items.length, 2);

      cartProvider.clear();

      expect(cartProvider.items, isEmpty);
      expect(cartProvider.total, 0.0);
      expect(cartProvider.isEmpty, true);
    });

    test('total should calculate sum of all item totals', () {
      final item1 = OrderItem(
        id: '1',
        name: 'Espresso',
        size: 'S',
        price: 200.0,
        imagePath: 'assets/images/espresso.png',
        quantity: 2,
      );

      final item2 = OrderItem(
        id: '2',
        name: 'Cappuccino',
        size: 'M',
        price: 250.0,
        imagePath: 'assets/images/cappuccino.png',
        quantity: 3,
      );

      cartProvider.addToCart(item1);
      cartProvider.addToCart(item2);

      // (200 * 2) + (250 * 3) = 400 + 750 = 1150
      expect(cartProvider.total, 1150.0);
    });

    test('items getter should return unmodifiable list', () {
      final item = OrderItem(
        id: '1',
        name: 'Mocha',
        size: 'M',
        price: 280.0,
        imagePath: 'assets/images/mocha.png',
      );

      cartProvider.addToCart(item);
      final items = cartProvider.items;

      expect(() => items.add(item), throwsUnsupportedError);
    });
  });
}
