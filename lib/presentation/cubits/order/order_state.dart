part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderLoaded extends OrderState {
  final List<Order> orders;
  final List<Order> activeOrders;
  final List<Order> pastOrders;
  final Order? currentOrder;
  final bool hasReachedMax;

  const OrderLoaded({
    required this.orders,
    required this.activeOrders,
    required this.pastOrders,
    this.currentOrder,
    this.hasReachedMax = false,
  });

  bool get hasOrders => orders.isNotEmpty;
  bool get hasActiveOrders => activeOrders.isNotEmpty;

  @override
  List<Object?> get props =>
      [orders, activeOrders, pastOrders, currentOrder, hasReachedMax];

  OrderLoaded copyWith({
    List<Order>? orders,
    List<Order>? activeOrders,
    List<Order>? pastOrders,
    Order? currentOrder,
    bool? hasReachedMax,
  }) {
    return OrderLoaded(
      orders: orders ?? this.orders,
      activeOrders: activeOrders ?? this.activeOrders,
      pastOrders: pastOrders ?? this.pastOrders,
      currentOrder: currentOrder ?? this.currentOrder,
    );
  }
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}
