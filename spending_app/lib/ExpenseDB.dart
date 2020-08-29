import 'dart:io';

import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'Expense.dart';
import 'dart:developer' as developer;

class ExpenseDB {
  Database _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initialize();
    }
    return _database;
  }

  ExpenseDB() {}

  initialize() async {
    var databasesPath = await getDatabasesPath();
    String path = Path.join(databasesPath, 'expenses_db.db');
    return openDatabase(
        path,
        version: 1,
        onOpen: (db) {

        },
        onCreate: (db, version) async {
          await db.execute("CREATE TABLE Expenses (id INTEGER PRIMARY KEY AUTOINCREMENT,"
              "price REAL, date TEXT, name TEXT)");
    }

    );
  }

  Future<List<Expense>> getAllExpenses() async {
    Database db = await database;
    List<Map> query = await db.rawQuery("SELECT * FROM Expenses ORDER BY date DESC");
    var result = List<Expense>();
    query.forEach((element) => result.add(Expense(element["id"], DateTime.parse(element["date"]), element["name"], element["price"])));

    result.forEach((element) { developer.log(element.id.toString()); });
    return result;
  }



  Future<void> addExpense(String name, double price, DateTime dateTime) async {
    Database db = await database;
    var dateAsString = dateTime.toString();
    await db.rawInsert("INSERT INTO Expenses (name, date, price) VALUES "
        "(\"$name\", \"$dateAsString\",\"$price\")");
  }

  Future<void> deleteExpense(int id) async {
    developer.log(id.toString());
    Database db = await database;
    var idAsString = id.toString();
    await db.rawDelete("DELETE FROM Expenses WHERE id = \"$idAsString\"");
  }

  Future<void> editExpense(String id, String name, double price) async {
    developer.log(id.toString());
    Database db = await database;
    await db.rawUpdate("UPDATE Expenses SET name = \"$name\", price = \"$price\" "
        "WHERE id = \"$id\"");
  }
}
