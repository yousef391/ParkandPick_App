import 'package:flutter/material.dart';
import 'package:testtt/data/models/order_item.dart';
import 'package:testtt/data/models/order_model.dart';
import 'package:testtt/data/models/station_model.dart';

/// Order Provider - State Management for Order History
/// Responsibilities:
/// - Store confirmed orders
/// - Track order status
/// - Provide order history
class OrderProvider extends ChangeNotifier {
  final List<Order> _orders = [];
  Order? _currentOrder;

  // Getters
  List<Order> get orders => List.unmodifiable(_orders);
  List<Order> get activeOrders => _orders
      .where((o) =>
          o.status != OrderStatus.completed &&
          o.status != OrderStatus.cancelled)
      .toList();
  List<Order> get pastOrders => _orders
      .where((o) =>
          o.status == OrderStatus.completed ||
          o.status == OrderStatus.cancelled)
      .toList();
  Order? get currentOrder => _currentOrder;
  bool get hasOrders => _orders.isNotEmpty;
  bool get hasActiveOrders => activeOrders.isNotEmpty;

  /// Create a new order from cart items
  Order createOrder({
    required List<OrderItem> items,
    required Station station,
    required double totalPrice,
  }) {
    final order = Order(
      id: _generateOrderId(),
      items: List.from(items),
      stationId: station.id,
      stationName: station.name,
      stationAddress: station.address,
      totalPrice: totalPrice,
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
      estimatedMinutes: station.etaMinutes + 5, // ETA + prep time
    );

    _orders.insert(0, order); // Add to beginning (most recent first)
    _currentOrder = order;
    notifyListeners();

    return order;
  }

  /// Update order status
  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(status: newStatus);
      if (_currentOrder?.id == orderId) {
        _currentOrder = _orders[index];
      }
      notifyListeners();
    }
  }

  /// Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  /// Cancel an order
  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  /// Mark order as preparing
  void markPreparing(String orderId) {
    updateOrderStatus(orderId, OrderStatus.preparing);
  }

  /// Mark order as ready for pickup
  void markReady(String orderId) {
    updateOrderStatus(orderId, OrderStatus.ready);
  }

  /// Mark order as completed
  void markCompleted(String orderId) {
    updateOrderStatus(orderId, OrderStatus.completed);
    if (_currentOrder?.id == orderId) {
      _currentOrder = null;
    }
  }

  /// Clear current order reference
  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
  }

  /// Generate unique order ID
  String _generateOrderId() {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch.toString().substring(5);
    return 'PP-$timestamp';
  }

  /// Reset provider state
  void reset() {
    _orders.clear();
    _currentOrder = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _orders.clear();
    super.dispose();
  }
}
