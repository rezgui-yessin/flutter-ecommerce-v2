import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider extends ChangeNotifier {
  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;
  bool get isLoading => _isLoading;

  final ApiService _apiService = ApiService();

  UserProvider() {
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _users = await _apiService.getUsers();
    } catch (e) {
      print('Error fetching users: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(User user) async {
    _isLoading = true;
    notifyListeners();
    try {
      // API Call
      await _apiService.addUser(user.toJson()); // Ignoring return as logic ID is unreliable
      
      // Fix for FakeID collision
      final uniqueId = DateTime.now().millisecondsSinceEpoch;
      final newUser = User(
        id: uniqueId,
        email: user.email,
        username: user.username,
        name: user.name,
        address: user.address,
        phone: user.phone,
      );

      _users.add(newUser);
      notifyListeners();
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(int id, User user) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.updateUser(id, user.toJson());
      
      final index = _users.indexWhere((u) => u.id == id);
      if (index != -1) {
        _users[index] = user; // Use 'user' which has updated fields but keep 'id' if needed
        // Ideally we ensure 'user' passed in has the correct final state
        notifyListeners();
      }
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteUser(int id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _apiService.deleteUser(id);
      _users.removeWhere((u) => u.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
