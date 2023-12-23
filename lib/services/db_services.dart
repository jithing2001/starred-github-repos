import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/model.dart';

class DatabaseServices {
  static const _databaseName = "RepositoryDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'repositories';
  static const columnDescription = 'description';
  static const columnStars = 'stars';
  static const columnUsername = 'username';
  static const columnAvatarUrl = 'avatar_url';

  DatabaseServices._privateConstructor();
  static final DatabaseServices instance = DatabaseServices._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnDescription TEXT NOT NULL,
            $columnStars INTEGER NOT NULL,
            $columnUsername TEXT NOT NULL,
            $columnAvatarUrl TEXT NOT NULL
          )
          ''');
  }

  Future insert(List<Items> itemsList) async {
    Database db = await instance.database;
    Batch batch = db.batch();

    for (var items in itemsList) {
      batch.insert(table, items.toJson());
    }
    await batch.commit();
  }

  Future<List<Items>> getRepositories(int page) async {
    Database db = await instance.database;
   
    //data starts at page 0
    var res = await db.query(table, limit: 30, offset: (page - 1) * 30);

    if (res.isEmpty) {
      return [];
    }

    //converting database map in to list of items
    List<Items> list = res.map((c) => Items.fromDb(c)).toList();
    return list;
  }

  Future cleardb() async {
    Database db = await DatabaseServices.instance.database;
    db.delete(table);
    final a = await db.query(table);
    log(a.toString());
  }
}
