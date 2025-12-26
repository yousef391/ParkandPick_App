import 'package:flutter/material.dart';
import 'package:testtt/data/models/order_item.dart';

/// Cart Provider - State Management for Shopping Cart
/// Responsibilities:
/// - Manage cart items (add, remove, update quantity)
/// - Calculate totals
/// - Handle cart state
class CartProvider extends ChangeNotifier {
  final List<OrderItem> _items = [];

  // Getters
  List<OrderItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;
  bool get isNotEmpty => _items.isNotEmpty;

  /// Get total price of all items in cart
  double get total {
    return _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  /// Add item to cart
  /// If item with same id and size exists, increment quantity instead
  void addToCart(OrderItem item) {
    final existingIndex = _items.indexWhere(
      (existing) => existing.id == item.id && existing.size == item.size,
    );

    if (existingIndex != -1) {
      // Update quantity of existing item
      final existing = _items[existingIndex];
      _items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + item.quantity,
      );
    } else {
      // Add new item
      _items.add(item);
    }
    notifyListeners();
  }

  /// Remove item from cart by id and size
  void removeFromCart(String itemId, String size) {
    _items.removeWhere((item) => item.id == itemId && item.size == size);
    notifyListeners();
  }

  /// Update quantity of an item
  void updateQuantity(String itemId, int newQuantity, {String? size}) {
    if (newQuantity <= 0) {
      // Remove item if quantity is 0 or less
      if (size != null) {
        removeFromCart(itemId, size);
      } else {
        _items.removeWhere((item) => item.id == itemId);
      }
      return;
    }

    final index = size != null
        ? _items.indexWhere((item) => item.id == itemId && item.size == size)
        : _items.indexWhere((item) => item.id == itemId);

    if (index != -1) {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
      notifyListeners();
    }
  }

  /// Increment quantity of an item
  void incrementQuantity(String itemId, {String? size}) {
    final index = size != null
        ? _items.indexWhere((item) => item.id == itemId && item.size == size)
        : _items.indexWhere((item) => item.id == itemId);

    if (index != -1) {
      final item = _items[index];
      updateQuantity(itemId, item.quantity + 1, size: size ?? item.size);
    }
  }

  /// Decrement quantity of an item
  void decrementQuantity(String itemId, {String? size}) {
    final index = size != null
        ? _items.indexWhere((item) => item.id == itemId && item.size == size)
        : _items.indexWhere((item) => item.id == itemId);

    if (index != -1) {
      final item = _items[index];
      if (item.quantity > 1) {
        updateQuantity(itemId, item.quantity - 1, size: size ?? item.size);
      } else {
        removeFromCart(itemId, size ?? item.size);
      }
    }
  }

  /// Clear entire cart
  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  /// Clear cart (alias for clearCart)
  void clear() {
    clearCart();
  }

  /// Get item by id and size
  OrderItem? getItem(String itemId, String size) {
    try {
      return _items.firstWhere(
        (item) => item.id == itemId && item.size == size,
      );
    } catch (e) {
      return null;
    }
  }

  /// Check if item exists in cart
  bool containsItem(String itemId, String size) {
    return _items.any((item) => item.id == itemId && item.size == size);
  }

  /// Reset provider state
  void reset() {
    _items.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _items.clear();
    super.dispose();
  }
}
