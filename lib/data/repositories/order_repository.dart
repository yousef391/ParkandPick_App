import 'package:dartz/dartz.dart' hide Order;
import 'package:injectable/injectable.dart' hide Order;
import 'package:testtt/core/failure.dart';
import 'package:testtt/data/models/order_item.dart';
import 'package:testtt/data/models/order_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:testtt/data/models/station_model.dart';

/// Order Repository - Handles order operations
abstract class OrderRepository {
  List<Order> get orders;
  List<Order> get activeOrders;
  List<Order> get pastOrders;

  Future<Either<Failure, Order>> createOrder({
    required List<OrderItem> items,
    required Station station,
    required double totalPrice,
  });

  Either<Failure, void> updateOrderStatus(
      String orderId, OrderStatus newStatus);
  Future<Either<Failure, List<Order>>> fetchOrders(
      {int page = 0, int limit = 10});
  Order? getOrderById(String orderId);
  void reset();
}

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  final List<Order> _orders = [];

  @override
  List<Order> get orders => List.unmodifiable(_orders);

  @override
  List<Order> get activeOrders => _orders
      .where((o) =>
          o.status != OrderStatus.completed &&
          o.status != OrderStatus.cancelled)
      .toList();

  @override
  List<Order> get pastOrders => _orders
      .where((o) =>
          o.status == OrderStatus.completed ||
          o.status == OrderStatus.cancelled)
      .toList();

  @override
  Future<Either<Failure, Order>> createOrder({
    required List<OrderItem> items,
    required Station station,
    required double totalPrice,
  }) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        return Left(ServerFailure('User not logged in'));
      }

      print('DEBUG: Attempting to create order...');
      print('DEBUG: User ID: $userId');
      print('DEBUG: Station ID: ${station.id}');
      print('DEBUG: Station Name: ${station.name}');

      // 1. Insert Order
      final orderData = Order.createSupabasePayload(
        userId: userId,
        stationId: station.id,
        stationName: station.name,
        stationAddress: station.address,
        totalPrice: totalPrice,
        estimatedMinutes: station.etaMinutes + 5,
      );

      final orderResponse = await Supabase.instance.client
          .from('orders')
          .insert(orderData)
          .select()
          .single();

      final orderId = orderResponse['id'];

      // 2. Insert Order Items
      final itemsData = items.map((item) {
        return {
          'order_id': orderId,
          'product_id': item.id, // Assuming item.id is product_id
          'quantity': item.quantity,
          'size': item.size,
          'price_at_time': 0, // You might want to pass price in OrderItem
          // 'addons': item.addons, // If addons exist
        };
      }).toList();

      await Supabase.instance.client.from('order_items').insert(itemsData);

      // 3. Create local Order object with generated ID
      final newOrder = Order(
        id: orderId,
        items: items,
        stationId: station.id,
        stationName: station.name,
        stationAddress: station.address,
        totalPrice: totalPrice,
        createdAt: DateTime.parse(orderResponse['created_at']),
        status: OrderStatus.pending,
        estimatedMinutes: station.etaMinutes + 5,
      );

      _orders.insert(0, newOrder);
      return Right(newOrder);
    } catch (e) {
      print('DEBUG: Error creating order: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Either<Failure, void> updateOrderStatus(
      String orderId, OrderStatus newStatus) {
    try {
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(status: newStatus);
        return const Right(null);
      }
      return const Left(ServerFailure('Order not found'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> fetchOrders(
      {int page = 0, int limit = 10}) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        return Left(ServerFailure('User not logged in'));
      }

      final from = page * limit;
      final to = from + limit - 1;

      final response = await Supabase.instance.client
          .from('orders')
          .select(
              '*, order_items(*, products(name, image_url, price)), stations(name, address)')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .range(from, to);

      final List<dynamic> data = response as List<dynamic>;

      // If refreshing (page 0), clear existing
      if (page == 0) {
        _orders.clear();
      }

      for (var orderJson in data) {
        // Avoid duplicates if any uniqueness check is needed,
        // but range-based usually suffices if data isn't moving fast.
        // We'll trust the database range here.
        final order = Order.fromSupabase(orderJson);
        if (!_orders.any((o) => o.id == order.id)) {
          _orders.add(order);
        }
      }

      // Sort again just in case, though DB sort should be enough
      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return Right(_orders);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  @override
  void reset() {
    _orders.clear();
  }
}
