import 'package:finziee_dart/models/category_model.dart';
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
      },
    );
  }

  static Future<int> insertCategory(CategoryModel category) async {
    final db = await database;
    return await db.insert('categories', category.toJson());
  }

  static Future<List<Map<String,dynamic>>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    print('size of fetched catagories: ${maps.length}');
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
    print('deleted all categories');
  }
}