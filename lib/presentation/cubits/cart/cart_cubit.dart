import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:testtt/data/models/order_item.dart';
import 'package:testtt/data/repositories/cart_repository.dart';

part 'cart_state.dart';

@injectable
class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository;

  CartCubit(this._cartRepository) : super(const CartState());

  void _emitCurrentState() {
    emit(CartState(
      items: _cartRepository.items,
      total: _cartRepository.total,
      itemCount: _cartRepository.itemCount,
    ));
  }

  /// Add item to cart
  void addToCart(OrderItem item) {
    _cartRepository.addToCart(item);
    _emitCurrentState();
  }

  /// Remove item from cart
  void removeFromCart(String itemId, String size) {
    _cartRepository.removeFromCart(itemId, size);
    _emitCurrentState();
  }

  /// Update quantity
  void updateQuantity(String itemId, int newQuantity, {String? size}) {
    _cartRepository.updateQuantity(itemId, newQuantity, size: size);
    _emitCurrentState();
  }

  /// Increment quantity
  void incrementQuantity(String itemId, {String? size}) {
    _cartRepository.incrementQuantity(itemId, size: size);
    _emitCurrentState();
  }

  /// Decrement quantity
  void decrementQuantity(String itemId, {String? size}) {
    _cartRepository.decrementQuantity(itemId, size: size);
    _emitCurrentState();
  }

  /// Get item by id and size
  OrderItem? getItem(String itemId, String size) {
    return _cartRepository.getItem(itemId, size);
  }

  /// Check if item exists in cart
  bool containsItem(String itemId, String size) {
    return _cartRepository.containsItem(itemId, size);
  }

  /// Clear entire cart
  void clearCart() {
    _cartRepository.clearCart();
    _emitCurrentState();
  }

  /// Reset (alias for clearCart)
  void reset() {
    clearCart();
  }
}
