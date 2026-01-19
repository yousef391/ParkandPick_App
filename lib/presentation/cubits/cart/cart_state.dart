part of 'cart_cubit.dart';

class CartState extends Equatable {
  final List<OrderItem> items;
  final double total;
  final int itemCount;

  const CartState({
    this.items = const [],
    this.total = 0.0,
    this.itemCount = 0,
  });

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;

  @override
  List<Object?> get props => [items, total, itemCount];

  CartState copyWith({
    List<OrderItem>? items,
    double? total,
    int? itemCount,
  }) {
    return CartState(
      items: items ?? this.items,
      total: total ?? this.total,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}
