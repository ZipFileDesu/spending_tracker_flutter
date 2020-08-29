import 'package:spending_app/ExpensesModel.dart';

class Expense
{
  final int id;
  final DateTime date;
  final String name;
  final double price;

  Expense(this.id, this.date, this.name, this.price);
}

String join(String a, String b) => "";