import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spending_app/Expense.dart';
import 'package:spending_app/ExpensesModel.dart';

class _EditExpenseState extends State<EditExpense> {
  String _id;
  double _price;
  String _name;
  ExpensesModel _model;
  Expense expense;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _EditExpenseState(this._model);

  @override
  Widget build(BuildContext context) {
    expense = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                autovalidate: true,
                initialValue: expense.price.toString(),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _price = double.parse(value);
                },
                validator: (value) {
                  if (double.tryParse(value) != null) {
                    return null;
                  } else {
                    return "Enter the valid price";
                  }
                },
              ),
              TextFormField(
                initialValue: expense.name,
                onSaved: (value) {
                  _name = value;
                },
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _model.EditExpense(expense.id.toString(), _name, _price);
                    Navigator.pop(context);
                  }
                },
                child: Text("Edit"),
              )
            ])),
      ),
    );
  }
}

class EditExpense extends StatefulWidget {
  final ExpensesModel _model;

  EditExpense(this._model);

  @override
  State<StatefulWidget> createState() {
    return _EditExpenseState(_model);
  }
}
