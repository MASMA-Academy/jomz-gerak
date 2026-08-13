import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  // ================================================================
  // DATABASE
  // ================================================================

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('app_user.db');

    return _database!;
  }

  // ================================================================
  // INITIALIZE DATABASE
  // ================================================================

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  // ================================================================
  // CREATE DATABASE
  // ================================================================

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE,
        phone TEXT UNIQUE,
        password TEXT NOT NULL,
        isLoggedIn INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // ==============================================================
    // DEMO ACCOUNT
    // ==============================================================

    await db.insert('users', {
      'name': 'Demo User',
      'email': 'demo@gmail.com',
      'phone': '0123456789',
      'password': '123456',
      'isLoggedIn': 0,
    });
  }

  // ================================================================
  // UPGRADE
  // ================================================================

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      try {
        await db.execute(
          'ALTER TABLE users '
          'ADD COLUMN password TEXT',
        );
      } catch (e) {
        // Column may already exist.
      }
    }
  }

  // ================================================================
  // LOGIN
  // ================================================================

  Future<Map<String, dynamic>?> loginUser({
    required String username,
    required String password,
  }) async {
    final db = await database;

    final cleanUsername = username.trim();

    final result = await db.query(
      'users',

      where: '''
        (LOWER(email) = LOWER(?) OR phone = ?)
        AND password = ?
      ''',

      whereArgs: [cleanUsername, cleanUsername, password],

      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    final user = result.first;

    // ==============================================================
    // SET CURRENT USER
    // ==============================================================

    await db.transaction((txn) async {
      // Logout all users first.

      await txn.update('users', {'isLoggedIn': 0});

      // Login selected user.

      await txn.update(
        'users',
        {'isLoggedIn': 1},

        where: 'id = ?',

        whereArgs: [user['id']],
      );
    });

    return {...user, 'isLoggedIn': 1};
  }

  // ================================================================
  // REGISTER
  // ================================================================

  Future<int> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final db = await database;

    return await db.insert('users', {
      'name': name.trim(),
      'email': email.trim().toLowerCase(),
      'phone': phone.trim(),
      'password': password,
      'isLoggedIn': 0,
    }, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  // ================================================================
  // GET CURRENT USER
  // ================================================================

  Future<Map<String, dynamic>?> getUserProfile() async {
    final db = await database;

    final result = await db.query(
      'users',

      where: 'isLoggedIn = ?',

      whereArgs: [1],

      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return result.first;
  }

  // ================================================================
  // CHECK LOGIN
  // ================================================================

  Future<bool> isLoggedIn() async {
    final user = await getUserProfile();

    return user != null;
  }

  // ================================================================
  // SAVE / UPDATE USER
  // ================================================================

  Future<void> saveUser(Map<String, dynamic> userData) async {
    final db = await database;

    final id = userData['id'];

    if (id != null) {
      await db.update('users', userData, where: 'id = ?', whereArgs: [id]);
    } else {
      await db.insert(
        'users',
        userData,

        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // ================================================================
  // UPDATE PROFILE
  // ================================================================

  Future<int> updateProfile({
    required int id,
    required String name,
    required String email,
    required String phone,
  }) async {
    final db = await database;

    return await db.update(
      'users',

      {
        'name': name.trim(),
        'email': email.trim().toLowerCase(),
        'phone': phone.trim(),
      },

      where: 'id = ?',

      whereArgs: [id],
    );
  }

  // ================================================================
  // LOGOUT
  // ================================================================

  Future<void> logout() async {
    final db = await database;

    await db.update('users', {'isLoggedIn': 0});
  }
}
