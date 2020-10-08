import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spending_app/Expense.dart';
import 'package:spending_app/ExpensesModel.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'dart:developer' as developer;

class _AddExpenseState extends State<AddExpense> {
  double _price;
  String _name;
  DateTime _dateTime = DateTime.now();
  ExpensesModel _model;
  Expense expense;
  final format = DateFormat("dd-MM-yyyy");
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  _AddExpenseState(this._model);

  @override
  Widget build(BuildContext context) {
    expense = ModalRoute.of(context).settings.arguments;
    double screen_width = MediaQuery.of(context).size.width;
    //developer.log(expense);
    return Scaffold(
      appBar: AppBar(
        title: Text(expense != null ? "Edit Expense" : "Add Expense"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Form(
            key: _formKey,
            child: Column(children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: Text("Value")),
                    SizedBox(
                      width: screen_width / (3 / 2),
                      child: TextFormField(
                        autovalidate: true,
                        initialValue: expense != null ? expense.price.toString() : "0",
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
                    ),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Text("Name")),
                  SizedBox(
                    width: screen_width / (3 / 2),
                    child: TextFormField(
                      initialValue: expense != null ? expense.name : "",
                      onSaved: (value) {
                        _name = value;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Text("Date")),
                  SizedBox(
                    width: screen_width / (3 / 2),
                    child: DateTimeField(
                      format: format,
                      initialValue: expense != null ? expense.date : _dateTime,
                      onShowPicker: (context, currentValue) {
                        //print(currentValue);
                        //_dateTime = currentValue;
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? _dateTime,
                            lastDate: DateTime(2100));
                      },
                        onSaved: (value) {
                        _dateTime = value;
                      }
                    ),
                  )
                ],
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate() && expense != null) {
                    _formKey.currentState.save();
                    _model.EditExpense(expense.id.toString(), _name, _price, _dateTime);
                    Navigator.pop(context);
                  }
                  else if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _model.AddExpense(_name, _price, _dateTime);
                    Navigator.pop(context);
                  }
                },
                child: Text("Add"),
              ),
            ])),
      ),
    );
  }
}

class AddExpense extends StatefulWidget {
  final ExpensesModel _model;

  AddExpense(this._model);

  @override
  State<StatefulWidget> createState() {
    return _AddExpenseState(_model);
  }
}
