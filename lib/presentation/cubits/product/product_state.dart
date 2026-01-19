part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {
  const ProductInitial();
}

class ProductLoading extends ProductState {
  const ProductLoading();
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String selectedCategory; // 'all' or category id
  final String searchQuery;
  final Product? selectedProduct;

  const ProductLoaded({
    required this.products,
    this.filteredProducts = const [],
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.selectedProduct,
  });

  @override
  List<Object?> get props => [
        products,
        filteredProducts,
        selectedCategory,
        searchQuery,
        selectedProduct
      ];

  ProductLoaded copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? selectedCategory,
    String? searchQuery,
    Product? selectedProduct,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }
}

class ProductError extends ProductState {
  final String message;
  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}
