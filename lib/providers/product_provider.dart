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

  // Mock data for Women's Clothing
  final List<Product> _womenClothingMockData = [
    Product(
      id: 101,
      title: "Women's Stylish Summer Dress",
      price: 29.99,
      description: "A beautiful and airy dress perfect for summer days. 100% Cotton.",
      category: "women's clothing",
      image: "https://fakestoreapi.com/img/61pHAEJ4NML._AC_UX679_.jpg",
      rating: Rating(rate: 4.5, count: 120),
    ),
    Product(
      id: 102,
      title: "Women's Casual T-Shirt",
      price: 15.99,
      description: "Comfortable casual t-shirt for everyday wear. Available in multiple colors.",
      category: "women's clothing",
      image: "https://fakestoreapi.com/img/51eg55uWmdL._AC_UX679_.jpg",
      rating: Rating(rate: 4.0, count: 85),
    ),
     Product(
      id: 103,
      title: "Women's Rain Jacket",
      price: 39.99,
      description: "Lightweight rain jacket. Waterproof and windproof.",
      category: "women's clothing",
      image: "https://fakestoreapi.com/img/71HblAHs5xL._AC_UY879_-2.jpg",
      rating: Rating(rate: 4.8, count: 200),
    ),
    Product(
      id: 104,
      title: "MBJ Women's Solid Short Sleeve Boat Neck V ",
      price: 9.85,
      description: "95% RAYON 5% SPANDEX, Made in USA or Imported, Do Not Bleach, Lightweight fabric with great stretch for comfort, Ribbed on sleeves and neckline / Double stitching on bottom hem",
      category: "women's clothing",
      image: "https://fakestoreapi.com/img/71z3kpMAYsL._AC_UY879_.jpg",
      rating: Rating(rate: 4.7, count: 130),
    ),
  ];

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
      final apiCategories = await _apiService.getCategories();
      _categories = List.from(apiCategories);
      
      // Ensure "women's clothing" is present
      if (!_categories.contains("women's clothing")) {
        _categories.add("women's clothing");
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching categories: $e');
      // Fallback categories if API fails
      if (_categories.isEmpty) {
        _categories = ['electronics', 'jewelery', "men's clothing", "women's clothing"];
        notifyListeners();
      }
    }
  }
  
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  Future<void> filterByCategory(String category) async {
     _selectedCategory = category;
     _isLoading = true;
    notifyListeners();
    try {
      if (category == 'All') {
         _products = await _apiService.getProducts();
      } else if (category == "women's clothing") {
          // Try API first, if empty match, use mock
          try {
             List<Product> apiProducts = await _apiService.getProductsByCategory(category);
             if (apiProducts.isNotEmpty) {
               _products = apiProducts;
             } else {
               _products = _womenClothingMockData;
             }
          } catch (_) {
             _products = _womenClothingMockData;
          }
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
