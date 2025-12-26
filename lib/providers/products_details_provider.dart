import 'package:flutter/material.dart';

class ProductDetailsProvider extends ChangeNotifier {
  bool _isFavorite = false;
  bool _isDescriptionExpanded = false;
  String _selectedSize = 'M';
  int _quantity = 1;
  List<String> _selectedAddons = [];

  String get selectedSized => _selectedSize;
  bool get isFavorite => _isFavorite;
  bool get isDescriptionExpanded => _isDescriptionExpanded;
  int get quantity => _quantity;
  List<String> get selectedAddons => List.unmodifiable(_selectedAddons);

  void toggleFavorite() {
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  void toggleDescriptionExpanded() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    notifyListeners();
  }

  void setSelectedSize(String size) {
    _selectedSize = size;
    notifyListeners();
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void setQuantity(int value) {
    if (value >= 1) {
      _quantity = value;
      notifyListeners();
    }
  }

  void toggleAddon(String addon) {
    if (_selectedAddons.contains(addon)) {
      _selectedAddons.remove(addon);
    } else {
      _selectedAddons.add(addon);
    }
    notifyListeners();
  }

  /// Reset state when leaving product details screen
  void resetState() {
    _selectedSize = 'M';
    _quantity = 1;
    _selectedAddons.clear();
    _isDescriptionExpanded = false;
    notifyListeners();
  }
}
