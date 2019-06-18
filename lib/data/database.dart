import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite/sqflite.dart';
import 'package:todo_app/data/todo_model.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;
    else {
      _database = await initDB();
      List<Todo> todos = await getAllTodos();
      if (todos.length == 0) await enterStartingData();
    }
    return _database;
  }

  initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'main.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int versions) async {
      await db.execute("CREATE TABLE Todo ("
          "id INTEGER PRIMARY KEY,"
          "item Text,"
          "completed BIT"
          ")");
    });
  }

  enterStartingData() async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Todo");
    int id = table.first['id'];
    var insert = await db.rawInsert(
        "INSERT Into Todo (id,item,completed)"
        " VALUES (?,?,?)",
        [id, 'Todo1', true]);
  }

  completedOrUncompleteTask(Todo todo) async {
    final db = await database;
    Todo completed =
        Todo(id: todo.id, item: todo.item, completed: !todo.completed);
      var res = await db.update("Todo", completed.toMap(), where: "id = ?", whereArgs: [todo.id]);
      return res;
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    var res = await db.query("Todo");
    List<Todo> list =
        res.isNotEmpty ? res.map((t) => Todo.fromMap(t)).toList() : [];
    return list;
  }
}
