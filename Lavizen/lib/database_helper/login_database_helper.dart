import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'user_login_database.db';
  static const String tableName = 'user_LoginData';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }
  Future<bool> hasData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return maps.isNotEmpty;
  }
  Future<Database> initDatabase() async {
    var documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  void _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        et_id INTEGER,
        et_name TEXT,
        et_add TEXT,
        et_email TEXT,
        et_contact TEXT,
        et_status INTEGER,
        et_designation TEXT,
        mseting_id INTEGER
      )
    ''');
  }
  Future<List<Map<String, dynamic>>> getUserData() async {
    final Database db = await database;
    return await db.query(tableName);
  }
  Future<int> insertUserData(Map<String, dynamic> data) async {
    final Database db = await database;
    return await db.insert(tableName, data);
  }
  Future<int> deleteData(String etId) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'et_id = ?',
      whereArgs: [etId],
    );
  }

}
