import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';

part 'product_details_state.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(const ProductDetailsState());

  void toggleFavorite() {
    emit(state.copyWith(isFavorite: !state.isFavorite));
  }

  void toggleDescriptionExpanded() {
    emit(state.copyWith(isDescriptionExpanded: !state.isDescriptionExpanded));
  }

  void setSelectedSize(String size) {
    emit(state.copyWith(selectedSize: size));
  }

  void incrementQuantity() {
    emit(state.copyWith(quantity: state.quantity + 1));
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void setQuantity(int value) {
    if (value >= 1) {
      emit(state.copyWith(quantity: value));
    }
  }

  void toggleAddon(String addon) {
    final addons = List<String>.from(state.selectedAddons);
    if (addons.contains(addon)) {
      addons.remove(addon);
    } else {
      addons.add(addon);
    }
    emit(state.copyWith(selectedAddons: addons));
  }

  /// Reset state when leaving product details screen
  void resetState() {
    emit(const ProductDetailsState());
  }

  /// Get selected size (getter for convenience)
  String get selectedSize => state.selectedSize;

  /// Get quantity (getter for convenience)
  int get quantity => state.quantity;

  /// Get selected addons (getter for convenience)
  List<String> get selectedAddons => state.selectedAddons;
}
