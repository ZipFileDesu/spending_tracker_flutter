import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spending_app/Expense.dart';
import 'package:spending_app/ExpensesModel.dart';
import 'package:intl/intl.dart';

class _EditExpenseState extends State<EditExpense> {
  String _id;
  double _price;
  String _name;
  DateTime _dateTime;
  ExpensesModel _model;
  Expense expense;
  final format = DateFormat("dd-MM-yyyy");
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
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Text("Value")),
                SizedBox(
                  width: 280,
                  child: TextFormField(
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
                )
              ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Text("Name")),
                  SizedBox(
                    width: 280,
                    child: TextFormField(
                    initialValue: expense.name,
                    onSaved: (value) {
                      _name = value;
                    },
                ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Text("Date")),
                  SizedBox(
                    width: 280,
                    child: DateTimeField(
                      format: format,
                      initialValue: expense.date,
                      onShowPicker: (context, currentValue) {
                        //print(currentValue);
                        //_dateTime = currentValue;
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: expense.date,
                            lastDate: DateTime(2100));
                      },
                      onSaved: (value) {
                        _dateTime = value;
                      },
                    ),
                  )
                ],
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    _model.EditExpense(expense.id.toString(), _name, _price, _dateTime);
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
