import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache{
  Database db;

  Future<List<int>> fetchTopIds() {
    return null;
  }

  NewsDbProvider() {
    print("#######initiating table!");
    init();
  }

  void init() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, "items_v2.db");

    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
          CREATE TABLE Items
            (
              id INTEGER PRIMARY KEY,
              type TEXT,
              by TEXT,
              time INTEGER,
              text TEXT,
              parent INTEGER,
              kids BLOB,
              dead INTEGER,
              deleted INTEGER,
              url TEXT,
              score INTEGER,
              title TEXT,
              descendants INTEGER            
            )
        """);
      }
    );
  }


  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length > 0 ) {
      ItemModel.fromDb(maps.first);
    }

    return null;
  }

  Future<int> addItem(ItemModel item) {
    return db.insert(
        "Items",
        item.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<int> clear() {
    return db.delete('Items');
  }
}

final newsDbProvider = NewsDbProvider();