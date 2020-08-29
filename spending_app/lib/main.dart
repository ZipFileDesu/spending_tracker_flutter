import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spending_app/AddExpense.dart';
import 'package:spending_app/Expense.dart';
import 'package:spending_app/ExpensesModel.dart';
import 'package:spending_app/Month.dart';
import 'AddExpense.dart';
import 'EditExpense.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Spending App'),
    );
  }
}
class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  List<Month> month = [
    Month(0, "All Month"),
    Month(1, "January"),
    Month(2, "February"),
    Month(3, "March"),
    Month(4, "April"),
    Month(5, "May"),
    Month(6, "June"),
    Month(7, "July"),
    Month(8, "August"),
    Month(9, "September"),
    Month(10, "October"),
    Month(11, "November"),
    Month(12, "December"),
  ];
  Month dropdownValue;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ExpensesModel>(
      model: ExpensesModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: <Widget>[
            ScopedModelDescendant<ExpensesModel>(
              builder: (context, child, model) => DropdownButton<Month>(
                value: dropdownValue,
                hint: Text("Select Month"),
                icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (Month newValue) {
                  dropdownValue = newValue;
                  model.FilterList(newValue.id);
                },
                items: month.map((Month value) {
                  return DropdownMenuItem<Month>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            )
          ],
        ),

        body: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) =>
              ListView.separated(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return ListTile(
                        title: Text("Total expenses: " + model.GetSum()),
                      );
                    } else {
                      --index;
                      return Dismissible(
                        key: Key(model.GetKey(index)),
                        background: Container(
                          alignment: AlignmentDirectional.centerEnd,
                          color: Colors.red,
                          ),
                        onDismissed: (direction) {
                          model.RemoveAt(index);
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Deleted record $index"),
                          ));
                        },
                        confirmDismiss: (DismissDirection direction) async {
                          return showAlertDialog(context);
                        },
                        child: ListTile(
                            title: Text(model.GetText(index)),
                            leading: IconButton(
                              icon: Icon(Icons.delete),
                              tooltip: 'Delete record',
                              onPressed: () async {
                                if (await showAlertDialog(context) == true){
                                  model.RemoveAt(index);
                                }
                              },
                            ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit),
                          tooltip: "Edit record",
                          onPressed: () async {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) {
                              return EditExpense(model);
                            },
                              settings: RouteSettings(
                                arguments: model.GetList(index),
                              ),
                            )
                            );
                          },
                        ),
                        onTap: () async {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) {
                            return EditExpense(model);
                          },
                            settings: RouteSettings(
                              arguments: model.GetList(index),
                            ),
                          )
                          );
                        },
                        ),
                      );
                    }
                  },
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: model.recordsCount + 1),
        ),
        floatingActionButton: ScopedModelDescendant<ExpensesModel>(
          builder: (context, child, model) => FloatingActionButton(
              tooltip: "Add record",
              onPressed: () {
                //model.AddExpense("Apple", 10);
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return AddExpense(model);
                  },
                ));
              },
              child: Icon(Icons.add)),
        ),
      ),
    );
  }
}

  Future<bool> showAlertDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Confirmation"),
          content: const Text("Are you sure you want to delete this item?"),
          actions: <Widget>[
            FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Delete")
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
}
