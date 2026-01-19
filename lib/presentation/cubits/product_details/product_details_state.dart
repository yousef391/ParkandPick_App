part of 'product_details_cubit.dart';

class ProductDetailsState extends Equatable {
  final bool isFavorite;
  final bool isDescriptionExpanded;
  final String selectedSize;
  final int quantity;
  final List<String> selectedAddons;

  const ProductDetailsState({
    this.isFavorite = false,
    this.isDescriptionExpanded = false,
    this.selectedSize = 'M',
    this.quantity = 1,
    this.selectedAddons = const [],
  });

  @override
  List<Object?> get props => [
        isFavorite,
        isDescriptionExpanded,
        selectedSize,
        quantity,
        selectedAddons,
      ];

  ProductDetailsState copyWith({
    bool? isFavorite,
    bool? isDescriptionExpanded,
    String? selectedSize,
    int? quantity,
    List<String>? selectedAddons,
  }) {
    return ProductDetailsState(
      isFavorite: isFavorite ?? this.isFavorite,
      isDescriptionExpanded:
          isDescriptionExpanded ?? this.isDescriptionExpanded,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
      selectedAddons: selectedAddons ?? this.selectedAddons,
    );
  }
}
