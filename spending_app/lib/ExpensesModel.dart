import 'dart:wasm';

import 'package:scoped_model/scoped_model.dart';
import 'package:spending_app/ExpenseDB.dart';
import 'Expense.dart';

class ExpensesModel extends Model {

  /*List<Expense> _items = [
    Expense(1, DateTime.now(), "Car", 5400),
    Expense(2, DateTime.now(), "Food", 757),
    Expense(3, DateTime.now(), "Fisting", 300),
  ];*/

  List<Expense> _items = [];
  //List<Expense> _tempList = [];


  ExpenseDB _database;

  ExpensesModel() {
    _database = ExpenseDB();
    GetAllExpenses();
  }

  int get recordsCount => _items.length;
  //int get filteredList => _tempList.length;

  void GetDropdownButtonText(){
    notifyListeners();
  }

  void GetAllExpenses() {
    Future<List<Expense>> task = _database.getAllExpenses();
    task.then((list) {
      _items.clear();
      _items = list;
      notifyListeners();
    });
  }

  Expense GetList(int index){
    return _items[index];
  }

  String GetKey(int index) {
    return _items[index].id.toString();
  }

  String GetText(int index) {
    var e = _items[index];
    if (e.price == 300){
      return e.name.toString() + " is " +
          e.price.toString() + " Bucks\n" + e.date.toString();
    }
      return e.name.toString() + " for " +
        e.price.toString() + " Dollars\n" + e.date.toString();
  }

  void FilterList(int month) async{
    Future<List<Expense>> task = _database.getAllExpenses();
    task.then((list) {
      if (month == 0) {
        _items = list;
      }
      else {
        _items = list.where((element) => element.date.month == month).toList();
      }
      notifyListeners();
    }
    );
  }

  String GetSum(){
    double sum = 0.0;
    _items.forEach((element) {
      sum += element.price;
    });
    return sum.toString();
  }

  void RemoveAt(int index) {
    Future<void> future = _database.deleteExpense(_items[index].id);
    _items.removeAt(index);
    future.then((value) {
      GetAllExpenses();
    }
    );
    notifyListeners();
  }

  void AddExpense(String name, double price, DateTime date) {
    Future<void> future = _database.addExpense(name, price, date);
    future.then((value) {
      GetAllExpenses();
    }
    );
    notifyListeners();
  }

  void EditExpense(String id, String name, double price, DateTime time) {
    Future<void> future = _database.editExpense(id, name, price, time);
    future.then((value) {
      GetAllExpenses();
    }
    );
    notifyListeners();
  }
}