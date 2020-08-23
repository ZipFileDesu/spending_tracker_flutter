import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class _MyAppState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                "spending tracker",
                textDirection: TextDirection.ltr,
              ),
            ),
            body: Container(
              color: Colors.blueGrey,
              child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: ListView.builder(itemBuilder: (context, i) {
                    if (i.isOdd) {
                      return Container(
                          child: Divider(
                        color: Colors.white,
                      ));
                    }
                    return Text("Index: $i");
                  })),
            )));
  }
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }

}