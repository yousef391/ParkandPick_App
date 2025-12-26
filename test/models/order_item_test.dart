import 'package:flutter_test/flutter_test.dart';
import 'package:testtt/data/models/order_item.dart';

void main() {
  group('OrderItem Model Tests', () {
    test('should create OrderItem with required fields', () {
      final item = OrderItem(
        id: '1',
        name: 'Cappuccino',
        size: 'M',
        price: 250.0,
        imagePath: 'assets/images/cappuccino.png',
      );

      expect(item.id, '1');
      expect(item.name, 'Cappuccino');
      expect(item.size, 'M');
      expect(item.price, 250.0);
      expect(item.imagePath, 'assets/images/cappuccino.png');
      expect(item.quantity, 1); // Default value
      expect(item.addons, isEmpty); // Default empty list
    });

    test('should create OrderItem with optional fields', () {
      final item = OrderItem(
        id: '2',
        name: 'Latte',
        size: 'L',
        price: 300.0,
        imagePath: 'assets/images/latte.png',
        quantity: 3,
        addons: ['Extra Shot', 'Vanilla Syrup'],
      );

      expect(item.quantity, 3);
      expect(item.addons, ['Extra Shot', 'Vanilla Syrup']);
    });

    test('totalPrice should calculate correctly', () {
      final item = OrderItem(
        id: '1',
        name: 'Espresso',
        size: 'S',
        price: 200.0,
        imagePath: 'assets/images/espresso.png',
        quantity: 4,
      );

      expect(item.totalPrice, 800.0);
    });

    test('toJson should serialize correctly', () {
      final item = OrderItem(
        id: '1',
        name: 'Mocha',
        size: 'M',
        price: 280.0,
        imagePath: 'assets/images/mocha.png',
        quantity: 2,
        addons: ['Whipped Cream'],
      );

      final json = item.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Mocha');
      expect(json['size'], 'M');
      expect(json['price'], 280.0);
      expect(json['imagePath'], 'assets/images/mocha.png');
      expect(json['quantity'], 2);
      expect(json['addons'], ['Whipped Cream']);
    });

    test('fromJson should deserialize correctly', () {
      final json = {
        'id': '3',
        'name': 'Americano',
        'size': 'L',
        'price': 220.0,
        'imagePath': 'assets/images/americano.png',
        'quantity': 5,
        'addons': ['Extra Hot'],
      };

      final item = OrderItem.fromJson(json);

      expect(item.id, '3');
      expect(item.name, 'Americano');
      expect(item.size, 'L');
      expect(item.price, 220.0);
      expect(item.imagePath, 'assets/images/americano.png');
      expect(item.quantity, 5);
      expect(item.addons, ['Extra Hot']);
    });

    test('fromJson should handle missing optional fields', () {
      final json = {
        'id': '4',
        'name': 'Flat White',
        'size': 'M',
        'price': 270.0,
        'imagePath': 'assets/images/flatwhite.png',
      };

      final item = OrderItem.fromJson(json);

      expect(item.quantity, 1); // Default
      expect(item.addons, isEmpty); // Default
    });

    test('copyWith should create new instance with updated fields', () {
      final original = OrderItem(
        id: '1',
        name: 'Cappuccino',
        size: 'M',
        price: 250.0,
        imagePath: 'assets/images/cappuccino.png',
        quantity: 1,
        addons: [],
      );

      final updated = original.copyWith(
        quantity: 3,
        addons: ['Cinnamon'],
      );

      // Original should be unchanged
      expect(original.quantity, 1);
      expect(original.addons, isEmpty);

      // Updated should have new values
      expect(updated.quantity, 3);
      expect(updated.addons, ['Cinnamon']);

      // Other fields should remain the same
      expect(updated.id, original.id);
      expect(updated.name, original.name);
      expect(updated.size, original.size);
      expect(updated.price, original.price);
      expect(updated.imagePath, original.imagePath);
    });

    test('copyWith should maintain immutability', () {
      final original = OrderItem(
        id: '1',
        name: 'Latte',
        size: 'L',
        price: 300.0,
        imagePath: 'assets/images/latte.png',
        quantity: 2,
      );

      final updated = original.copyWith(quantity: 5);

      expect(original.quantity, 2);
      expect(updated.quantity, 5);
      expect(identical(original, updated), false);
    });

    test('toJson and fromJson should be reversible', () {
      final original = OrderItem(
        id: '1',
        name: 'Macchiato',
        size: 'S',
        price: 230.0,
        imagePath: 'assets/images/macchiato.png',
        quantity: 3,
        addons: ['Caramel', 'Extra Foam'],
      );

      final json = original.toJson();
      final restored = OrderItem.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.size, original.size);
      expect(restored.price, original.price);
      expect(restored.imagePath, original.imagePath);
      expect(restored.quantity, original.quantity);
      expect(restored.addons, original.addons);
    });
  });
}
