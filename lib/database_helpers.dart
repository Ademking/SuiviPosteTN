import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableSearch = 'search';
final String columnId = '_id';
final String columnCode = 'code';
final String columnTimestamp = 'timestamp';

// data model class
class Search {
  int id;
  String code;
  String timestamp;

  Search();

  // convenience constructor to create a Search object
  Search.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    code = map[columnCode];
    timestamp = map[columnTimestamp];
  }

  // convenience method to create a Map from this Search object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnCode: code, columnTimestamp: timestamp};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {
  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "Search.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableSearch (
                $columnId INTEGER PRIMARY KEY,
                $columnCode TEXT NOT NULL,
                $columnTimestamp TEXT NOT NULL
              )
              ''');
  }

  // Database helper methods:

  Future<int> insert(Search search) async {
    Database db = await database;
    int id = await db.insert(tableSearch, search.toMap());
    return id;
  }

  Future<Search> querysearch(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableSearch,
        columns: [columnId, columnCode, columnTimestamp],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Search.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Search>> queryAllCodes() async {
    Database db = await database;
    List<Map> maps = await db.query(tableSearch);
    if (maps.length > 0) {
      List<Search> words = [];
      maps.forEach((map) => words.add(Search.fromMap(map)));
      return words;
    }
    return null;
  }

  Future<int> deleteSearch(int id) async {
    Database db = await database;
    return await db.delete(tableSearch, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Search search) async {
    Database db = await database;
    return await db.update(tableSearch, search.toMap(),
        where: '$columnId = ?', whereArgs: [search.id]);
  }

  Future<int> deleteAll() async {
    Database db = await database;
    return await db.delete(tableSearch);
  }

  Future<int> dropTable() async {
    Database db = await database;
  }

 String get code {
    return code;
  }

  String get timestamp {
    return timestamp;
  }

  // TODO: queryAllsearchs()
  // TODO: delete(int id)
  // TODO: update(search search)
}
