import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('finshop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        email TEXT NOT NULL,
        firstname TEXT NOT NULL,
        lastname TEXT NOT NULL
      )
    ''');

    // Products table
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT NOT NULL,
        category TEXT NOT NULL,
        image TEXT NOT NULL,
        rating_rate REAL DEFAULT 0.0,
        rating_count INTEGER DEFAULT 0
      )
    ''');
  }

  // ========== USER AUTH METHODS ==========
  
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<bool> userExists(String username) async {
    final db = await database;
    final results = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return results.isNotEmpty;
  }

  // ========== USER MANAGEMENT (ADMIN) ==========
  
  Future<List<UserModel>> getAllUsers() async {
    final db = await database;
    final results = await db.query('users');
    return results.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ========== PRODUCT CRUD METHODS ==========
  
  Future<int> insertProduct(Product product) async {
    final db = await database;
    return await db.insert('products', {
      'title': product.title,
      'price': product.price,
      'description': product.description,
      'category': product.category,
      'image': product.image,
      'rating_rate': product.rating.rate,
      'rating_count': product.rating.count,
    });
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final results = await db.query('products');
    return results.map((json) => Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: Rating(
        rate: (json['rating_rate'] as num).toDouble(),
        count: json['rating_count'] as int,
      ),
    )).toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final db = await database;
    final results = await db.query(
      'products',
      where: 'category = ?',
      whereArgs: [category],
    );
    return results.map((json) => Product(
      id: json['id'] as int,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      category: json['category'] as String,
      image: json['image'] as String,
      rating: Rating(
        rate: (json['rating_rate'] as num).toDouble(),
        count: json['rating_count'] as int,
      ),
    )).toList();
  }

  Future<int> updateProduct(int id, Product product) async {
    final db = await database;
    return await db.update(
      'products',
      {
        'title': product.title,
        'price': product.price,
        'description': product.description,
        'category': product.category,
        'image': product.image,
        'rating_rate': product.rating.rate,
        'rating_count': product.rating.count,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<String>> getCategories() async {
    final db = await database;
    final results = await db.rawQuery('SELECT DISTINCT category FROM products');
    return results.map((row) => row['category'] as String).toList();
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
