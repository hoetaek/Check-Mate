import 'dart:io';

import 'package:check_mate/models/item_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class TodoDbProvider {
  Database db;

  Future init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db");
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
        CREATE TABLE Items
        (
        id INTEGER PRIMARY KEY,
        title TEXT,
        done INTEGER,
        idx INTEGER,
        success INTEGER,
        level INTEGER
        )
        """);
      },
    );
  }

  Future<List<ItemModel>> fetchItems() async {
    final maps = await db.query(
      "Items",
      columns: null,
      orderBy: "idx ASC",
    );
    if (maps.length > 0) {
      return maps.map((itemData) => ItemModel.fromDb(itemData)).toList();
    }
    return null;
  }

  addItem(ItemModel item) {
    return db.insert('Items', item.toMapForDb());
  }

  updateItem(ItemModel item) {
    return db.update("Items", item.toMapForDb(),
        where: "id = ?", whereArgs: [item.id]);
  }

  deleteItem(ItemModel item) {
    return db.delete(
      'Items',
      where: "id = ?",
      whereArgs: [item.id],
    );
  }
}
