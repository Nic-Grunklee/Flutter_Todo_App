import 'package:flutter/material.dart';

import 'data/todo_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [
    Todo(id: 1, item: 'Todo1', completed: false),
    Todo(id: 2, item: 'Todo2', completed: true),
    Todo(id: 3, item: 'Todo3', completed: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(children: todos.map((todo) => _buildTile(todo)).toList()),
    );
  }

  Widget _buildTile(Todo todo) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListTile(
        title: Text(todo.item),
        trailing: Checkbox(
          value: todo.completed,
          onChanged: (value) {
            setState(() {
              todo.completed = value;  
            });
          },
        ),
      ),
    );
  }
}
