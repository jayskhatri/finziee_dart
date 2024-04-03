import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/models/recurrence_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() => _instance;

  DBHelper._internal();

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'categories.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String categoriesTableCreationQuery = '''
          CREATE TABLE IF NOT EXISTS categories(
            cat_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            cat_name TEXT NOT NULL,
            cat_type INTEGER DEFAULT 0,
            cat_count INTEGER, 
            cat_color STRING, 
            cat_is_fav BOOL DEFAULT 0
          )
        ''';
        await db.execute(categoriesTableCreationQuery);

        String transactionsTableCreationQuery = '''
          CREATE TABLE transactions (
            id INTEGER NOT NULL PRIMARY KEY autoincrement, 
            comment TEXT,
            amount TEXT NOT NULL DEFAULT '0', 
            date DATE NOT NULL, 
            cat_id INTEGER NOT NULL, 
            is_auto_added INTEGER DEFAULT 0, 
            img_path TEXT, 
            FOREIGN KEY(cat_id) REFERENCES categories(cat_id)
          )
        ''';
        // await db.execute(transactionsTableCreationQuery);

        String recurringTableCreationQuery = '''
          CREATE TABLE recurrence(
            recur_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
            recur_amount TEXT, 
            recur_note TEXT, 
            recur_cat_id INTEGER,
            recur_type INTEGER, 
            recur_on TEXT
          )''';
        await db.execute(recurringTableCreationQuery);
      },
    );
  }


  //TRANSACTIONS TABLE CRUD OPERATIONS
  static Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction);
  }

  static Future<List<Map<String,dynamic>>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return maps;
  }

  static Future<int> updateTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction,
      where: 'id = ?',
      whereArgs: [transaction['id']],
    );
  }

  static Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getTransactionById(int id) async {
    final db = await database;
    return db.query('transactions',where: 'id=?',whereArgs: [id],limit: 1);
  }

  static void deleteAllTransactions() async {
    final db = await database;
    String query = 'DROP TABLE IF EXISTS transactions';
    await db.execute(query);
  }


  //CATAGORIES TABLE CRUD OPERATIONS
  static Future<int> insertCategory(CategoryModel category) async {
    final db = await database;
    return await db.insert('categories', category.toJson());
  }

  static Future<List<Map<String,dynamic>>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return maps;
  }

  static Future<int> updateCategory(CategoryModel category) async {
    final db = await database;
    return await db.update(
      'categories',
      category.toJson(),
      where: 'cat_id = ?',
      whereArgs: [category.catId],
    );
  }

  static Future<int> deleteCategory(int id) async {
    final db = await database;
    return await db.delete(
      'categories',
      where: 'cat_id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getCategoryById(int id) async {
    final db = await database;
    return db.query('categories',where: 'id=?',whereArgs: [id],limit: 1);
  }

  static void deleteAllCategories() async {
    final db = await database;
    String query = 'DROP TABLE IF EXISTS categories';
    await db.execute(query);
  }

  //RECURRENCE TABLE CRUD OPERATIONS
  static Future<int> insertRecurrence(RecurrenceModel recurrence) async {
    final db = await database;
    return await db.insert('recurrence', recurrence.toJson());
  }

  static Future<List<Map<String,dynamic>>> getRecurrences() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recurrence');
    return maps;
  }

  static Future<int> updateRecurrence(RecurrenceModel recurrence) async {
    final db = await database;
    return await db.update(
      'recurrence',
      recurrence.toJson(),
      where: 'recur_id = ?',
      whereArgs: [recurrence.recurId],
    );
  }

  static Future<int> deleteRecurrence(int id) async {
    final db = await database;
    return await db.delete(
      'recurrence',
      where: 'recur_id = ?',
      whereArgs: [id],
    );
  }

  static Future<List<Map<String, dynamic>>> getRecurrenceById(int id) async {
    final db = await database;
    return db.query('recurrence',where: 'recur_id=?',whereArgs: [id],limit: 1);
  }

  static void deleteAllRecurrences() async {
    final db = await database;
    String query = 'DROP TABLE IF EXISTS recurrence';
    await db.execute(query);
  }
}