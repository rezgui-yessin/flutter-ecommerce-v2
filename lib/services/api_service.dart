import 'package:dio/dio.dart';
import '../models/product.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: AppConstants.apiBaseUrl));

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // --- Auth ---

  Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'username': username,
        'password': password,
      });
      return response.data['token'];
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.unknown) {
         throw Exception('No Internet Connection. Please check your network.');
      }
      throw Exception('Failed to login: ${e.response?.data ?? e.message}');
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<void> signup(String email, String username, String password, String firstname, String lastname) async {
    try {
      // FakeStore uses specific structure for users
      await _dio.post('/users', data: {
        'email': email,
        'username': username,
        'password': password,
        'name': {
          'firstname': firstname,
          'lastname': lastname
        },
        'address': {
          'city': 'kilcoole',
          'street': '7835 new road',
          'number': 3,
          'zipcode': '12926-3874',
          'geolocation': {
            'lat': '-37.3159',
            'long': '81.1496'
          }
        }, 
        'phone': '1-570-236-7033'
      });
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError || e.type == DioExceptionType.unknown) {
         throw Exception('No Internet Connection. Please check your network.');
      }
      throw Exception('Failed to sign up: ${e.response?.data ?? e.message}');
    } catch (e) {
       throw Exception('Failed to sign up: $e');
    }
  }

  // --- Products ---

  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await _dio.get('/products/$id');
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response = await _dio.get('/products/categories');
      List<dynamic> data = response.data;
      return data.map((e) => e.toString()).toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final response = await _dio.get('/products/category/$category');
      List<dynamic> data = response.data;
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load category products: $e');
    }
  }

  Future<Product> addProduct(Map<String, dynamic> productData) async {
    try {
      final response = await _dio.post('/products', data: productData);
      // FakeStoreAPI returns the object with a NEW ID
      return Product.fromJson({...productData, 'id': response.data['id']});
    } catch (e) {
      throw Exception('Failed to add product: $e');
    }
  }

  Future<Product> updateProduct(int id, Map<String, dynamic> productData) async {
    try {
      // FakeStoreAPI just echoes back the data
      await _dio.put('/products/$id', data: productData);
      return Product.fromJson({...productData, 'id': id});
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }

  // --- Users ---

  Future<List<User>> getUsers() async {
    try {
      final response = await _dio.get('/users');
      List<dynamic> data = response.data;
      return data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<User> addUser(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/users', data: userData);
      // FakeStoreAPI returns the ID
      return User.fromJson({...userData, 'id': response.data['id']});
    } catch (e) {
      throw Exception('Failed to add user: $e');
    }
  }

  Future<User> updateUser(int id, Map<String, dynamic> userData) async {
    try {
      await _dio.put('/users/$id', data: userData);
      return User.fromJson({...userData, 'id': id});
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      await _dio.delete('/users/$id');
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }
}
