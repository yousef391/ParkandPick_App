import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testtt/data/models/order_item.dart';
import 'package:testtt/data/models/order_model.dart';
import 'package:testtt/data/models/station_model.dart';
import 'package:testtt/data/repositories/order_repository.dart';
import 'package:injectable/injectable.dart' hide Order;

part 'order_state.dart';

@injectable
class OrderCubit extends Cubit<OrderState> {
  final OrderRepository _orderRepository;

  OrderCubit(this._orderRepository) : super(const OrderInitial());

  void _emitCurrentState({Order? currentOrder, bool hasReachedMax = false}) {
    // If we are already loaded, preserve the previous hasReachedMax unless specificed
    bool finalHasReachedMax = hasReachedMax;
    if (state is OrderLoaded && !hasReachedMax) {
      // If not explicitly setting to true/false (default false), check previous
      // logic here is simplified: Repository handles merging, we just emit what we know.
      // But wait, hasReachedMax is determined by the *latest fetch*.
      // If we didn't fetch, we shouldn't change it.
      // Simplification: Caller MUST provide it correct if recently fetched.
      // Use existing from state if available?
      if (state is OrderLoaded) {
        finalHasReachedMax = (state as OrderLoaded).hasReachedMax;
      }
    }
    // Actually, createOrder calls this without fetching, so hasReachedMax shouldn't change.

    emit(OrderLoaded(
      orders: _orderRepository.orders,
      activeOrders: _orderRepository.activeOrders,
      pastOrders: _orderRepository.pastOrders,
      currentOrder: currentOrder ??
          (state is OrderLoaded ? (state as OrderLoaded).currentOrder : null),
      hasReachedMax: finalHasReachedMax,
    ));
  }

  int _currentPage = 0;
  static const int _limit = 10;
  bool _isFetching = false;

  /// Load orders from repository
  Future<void> loadOrders({bool refresh = false}) async {
    if (_isFetching) return;

    if (refresh) {
      _currentPage = 0;
      emit(
          const OrderLoading()); // Or keep showing list and show loading indicator
    }

    _isFetching = true;
    final result = await _orderRepository.fetchOrders(
      page: _currentPage,
      limit: _limit,
    );
    _isFetching = false;

    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (newOrders) {
        final hasReachedMax = newOrders.length < _limit;
        // If refreshing, repository clears internal list, so just emit state
        // Repository's getter returns the full list from memory which is now refreshed
        _emitCurrentState(hasReachedMax: hasReachedMax);
      },
    );
  }

  /// Load next page
  Future<void> loadMoreOrders() async {
    final currentState = state;
    if (_isFetching ||
        currentState is! OrderLoaded ||
        currentState.hasReachedMax) return;

    _currentPage++;
    _isFetching = true;

    final result =
        await _orderRepository.fetchOrders(page: _currentPage, limit: _limit);
    _isFetching = false;

    result.fold(
      (failure) {
        // Just show snackbar or ignore? For now ignore or emit error (might replace screen)
        // ideally we have a separate 'loading more' failure state or just use a toast
        // Reverting page
        _currentPage--;
      },
      (newOrders) {
        final hasReachedMax = newOrders.length < _limit;
        _emitCurrentState(hasReachedMax: hasReachedMax);
      },
    );
  }

  /// Create a new order
  Future<void> createOrder({
    required List<OrderItem> items,
    required Station station,
    required double totalPrice,
  }) async {
    emit(const OrderLoading());
    final result = await _orderRepository.createOrder(
      items: items,
      station: station,
      totalPrice: totalPrice,
    );
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (order) => _emitCurrentState(currentOrder: order),
    );
  }

  /// Update order status
  void updateOrderStatus(String orderId, OrderStatus newStatus) {
    final result = _orderRepository.updateOrderStatus(orderId, newStatus);
    result.fold(
      (failure) => emit(OrderError(failure.message)),
      (_) {
        final currentState = state;
        if (currentState is OrderLoaded) {
          final updatedOrder = newStatus == OrderStatus.completed
              ? null
              : currentState.currentOrder?.id == orderId
                  ? _orderRepository.getOrderById(orderId)
                  : currentState.currentOrder;
          _emitCurrentState(currentOrder: updatedOrder);
        }
      },
    );
  }

  /// Cancel an order
  void cancelOrder(String orderId) {
    updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  /// Mark order as preparing
  void markPreparing(String orderId) {
    updateOrderStatus(orderId, OrderStatus.preparing);
  }

  /// Mark order as ready
  void markReady(String orderId) {
    updateOrderStatus(orderId, OrderStatus.ready);
  }

  /// Mark order as completed
  void markCompleted(String orderId) {
    updateOrderStatus(orderId, OrderStatus.completed);
  }

  /// Get order by ID
  Order? getOrderById(String orderId) {
    return _orderRepository.getOrderById(orderId);
  }

  /// Clear current order reference
  void clearCurrentOrder() {
    final currentState = state;
    if (currentState is OrderLoaded) {
      emit(currentState.copyWith(currentOrder: null));
    }
  }

  /// Reset state
  void reset() {
    _orderRepository.reset();
    emit(const OrderInitial());
  }
}
