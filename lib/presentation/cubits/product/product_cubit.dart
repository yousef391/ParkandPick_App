import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:testtt/data/models/product_model.dart';
import 'package:testtt/data/repositories/product_repository.dart';

part 'product_state.dart';

@injectable
class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _productRepository;

  ProductCubit(this._productRepository) : super(const ProductInitial());

  /// Fetch all products
  Future<void> fetchProducts() async {
    emit(const ProductLoading());
    final result = await _productRepository.fetchProducts();
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(
        products: products,
        filteredProducts: products, // Initially show all
        selectedCategory: 'all',
        searchQuery: '',
      )),
    );
  }

  /// Filter products by category
  void filterByCategory(String category) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      final filtered = _applyFilters(
        currentState.products,
        category,
        currentState.searchQuery,
      );
      emit(currentState.copyWith(
        selectedCategory: category,
        filteredProducts: filtered,
      ));
    } else {
      // Logic if not loaded yet? Maybe fetch with category?
      // Since fetchProducts loads all, we assume we have everything.
      // Or we can call fetchProductsByCategory if API supports it and we prefer that.
      // But typically we load all once for smooth filtering.
      // If we want API filtering, we would call fetchProductsByCategory.
      // Here implementing client-side filtering on loaded list.
    }
  }

  /// Search products
  void searchProducts(String query) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      final filtered = _applyFilters(
        currentState.products,
        currentState.selectedCategory,
        query,
      );
      emit(currentState.copyWith(
        searchQuery: query,
        filteredProducts: filtered,
      ));
    }
  }

  /// Helper to apply both filters
  List<Product> _applyFilters(
      List<Product> allProducts, String category, String query) {
    return allProducts.where((product) {
      // Category filter
      final matchCategory = category == 'all' ||
          product.category.toLowerCase() ==
              category.toLowerCase(); // Case insensitive safety

      // Search filter
      final matchSearch = query.isEmpty ||
          product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase());

      return matchCategory && matchSearch;
    }).toList();
  }

  // Legacy fetch by category if needed (server side)
  // But usually home screen loads all.
  // I will keep logic consistent: load all then filter.

  /// Get product by ID
  Product? getProductById(String id) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      try {
        return currentState.products.firstWhere((p) => p.id == id);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Select product for detail view
  void selectProduct(Product product) {
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(currentState.copyWith(selectedProduct: product));
    }
  }

  /// Clear selected product
  void clearSelectedProduct() {
    final currentState = state;
    if (currentState is ProductLoaded) {
      // Just clear selection
      emit(currentState.copyWith(selectedProduct: null));
    }
  }

  /// Refresh products
  Future<void> refresh() async {
    await fetchProducts();
  }

  /// Reset state
  void reset() {
    emit(const ProductInitial());
  }
}
