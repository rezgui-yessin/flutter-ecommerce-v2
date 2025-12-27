import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<String> _categories = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Product> get products => _searchQuery.isEmpty ? _products : _filteredProducts;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  ProductProvider() {
    fetchProducts();
    fetchCategories();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _apiService.getProducts();
    } catch (e) {
      print('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    try {
      _categories = await _apiService.getCategories();
      notifyListeners();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
  
  Future<void> filterByCategory(String category) async {
     _isLoading = true;
    notifyListeners();
    try {
      if (category == 'All') {
         _products = await _apiService.getProducts();
      } else {
         _products = await _apiService.getProductsByCategory(category);
      }
    } catch (e) {
      print('Error fetching category products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchProducts(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredProducts = [];
    } else {
      _filteredProducts = _products.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
  
  List<Product> getSuggestions(String query) {
    if (query.isEmpty) return [];
    return _products.where((product) {
      return product.title.toLowerCase().contains(query.toLowerCase());
    }).take(5).toList();
  }
}
