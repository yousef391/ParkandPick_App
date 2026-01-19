part of 'favorites_cubit.dart';

class FavoritesState extends Equatable {
  final List<Product> favorites;
  final bool isLoading;

  const FavoritesState({
    this.favorites = const [],
    this.isLoading = false,
  });

  bool get isEmpty => favorites.isEmpty;

  @override
  List<Object?> get props => [favorites, isLoading];

  FavoritesState copyWith({
    List<Product>? favorites,
    bool? isLoading,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
