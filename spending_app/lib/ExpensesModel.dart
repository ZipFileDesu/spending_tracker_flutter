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

  ExpenseDB _database;

  ExpensesModel() {
    _database = ExpenseDB();
    GetAllExpenses();
  }

  int get recordsCount => _items.length;

  void load() {

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
    return e.name.toString() + " for " +
        e.price.toString() + "\n" + e.date.toString();
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

  void AddExpense(String name, double price) {
    Future<void> future = _database.addExpense(name, price, DateTime.now());
    future.then((value) {
      GetAllExpenses();
    }
    );
    notifyListeners();
  }

  void EditExpense(String id, String name, double price) {
    Future<void> future = _database.editExpense(id, name, price);
    future.then((value) {
      GetAllExpenses();
    }
    );
    notifyListeners();
  }
}