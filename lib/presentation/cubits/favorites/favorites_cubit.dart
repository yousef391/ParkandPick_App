import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:equatable/equatable.dart';
import 'package:testtt/data/models/product_model.dart';
import 'package:testtt/data/repositories/favorites_repository.dart';

part 'favorites_state.dart';

@injectable
class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _favoritesRepository;

  FavoritesCubit(this._favoritesRepository) : super(const FavoritesState());

  void _emitCurrentState() {
    emit(FavoritesState(favorites: _favoritesRepository.favorites));
  }

  /// Load favorites (for initial load)
  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(const Duration(milliseconds: 200));
    _emitCurrentState();
  }

  /// Check if product is favorite
  bool isFavorite(String productId) {
    return _favoritesRepository.isFavorite(productId);
  }

  /// Toggle favorite status
  void toggleFavorite(Product product) {
    _favoritesRepository.toggleFavorite(product);
    _emitCurrentState();
  }

  /// Add to favorites
  void addFavorite(Product product) {
    _favoritesRepository.addFavorite(product);
    _emitCurrentState();
  }

  /// Remove from favorites
  void removeFavorite(String productId) {
    _favoritesRepository.removeFavorite(productId);
    _emitCurrentState();
  }

  /// Clear all favorites
  void clear() {
    _favoritesRepository.clear();
    _emitCurrentState();
  }
}
