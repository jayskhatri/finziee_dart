import 'package:finziee_dart/models/category_model.dart';
import 'package:finziee_dart/models/transaction_model.dart';
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
            description TEXT,
            amount FLOAT NOT NULL DEFAULT '0', 
            date TEXT NOT NULL, 
            cat_id INTEGER NOT NULL, 
            is_auto_added INTEGER DEFAULT 0, 
            FOREIGN KEY(cat_id) REFERENCES categories(cat_id)
          )
        ''';
        await db.execute(transactionsTableCreationQuery);
      },
    );
  }


  //TRANSACTIONS TABLE CRUD OPERATIONS
  static Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toJson());
  }

  static Future<List<Map<String,dynamic>>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return maps;
  }

  static Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toJson(),
      where: 'id = ?',
      whereArgs: [transaction.id],
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
    return db.query('categories',where: 'cat_id=?',whereArgs: [id],limit: 1);
  }

  static void deleteAllCategories() async {
    final db = await database;
    String query = 'DROP TABLE IF EXISTS categories';
    await db.execute(query);
  }
}