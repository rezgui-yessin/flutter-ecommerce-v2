import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/database_helper.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  int? _userId;
  String? _username;
  String? _email;
  
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  int? get userId => _userId;
  String? get username => _username;
  String? get email => _email;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _userId = prefs.getInt('user_id');
    _username = prefs.getString('username');
    _email = prefs.getString('email');
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Check database for user
      final user = await _dbHelper.getUser(username, password);
      
      if (user != null) {
        // Generate a simple token (in production, use proper JWT)
        _token = 'local_token_${user['id']}_${DateTime.now().millisecondsSinceEpoch}';
        _userId = user['id'] as int;
        _username = user['username'] as String;
        _email = user['email'] as String;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', _token!);
        await prefs.setInt('user_id', _userId!);
        await prefs.setString('username', _username!);
        await prefs.setString('email', _email!);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Invalid username or password');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> signup(String email, String username, String password, String firstname, String lastname) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Check if username already exists
      final exists = await _dbHelper.userExists(username);
      if (exists) {
        _isLoading = false;
        notifyListeners();
        throw Exception('Username already exists');
      }
      
      // Create user model
      final user = UserModel(
        username: username,
        password: password,
        email: email,
        firstname: firstname,
        lastname: lastname,
      );
      
      // Insert into database
      await _dbHelper.insertUser(user.toJson());
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _username = null;
    _email = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('username');
    await prefs.remove('email');
    notifyListeners();
  }
  
  Future<String?> getUsername() async {
    if (_username != null) return _username;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
  
  Future<String?> getEmail() async {
    if (_email != null) return _email;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }
}
