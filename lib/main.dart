import 'package:flutter/material.dart';
import 'package:todo_app/data/database.dart';
import 'package:provider/provider.dart';

import 'state/app_state.dart';
import 'data/todo_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => AppState()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
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
  int _currentIndex = 0;
  final List<Widget> _children = [Todos(), Completed()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _children[Provider.of<AppState>(context).bottomIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), title: Text("Todos")),
          BottomNavigationBarItem(
              icon: Icon(Icons.check), title: Text("Completed")),
        ],
        currentIndex: Provider.of<AppState>(context).bottomIndex,
        onTap: (index) {
          Provider.of<AppState>(context).changeBottomIndex(index);
        },
      ),
    );
  }
}

class Todos extends StatefulWidget {
  @override
  _TodosState createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: textController,
                decoration: InputDecoration(hintText: "What to do?"),
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                DBProvider.db.newTodo(textController.text);
                setState(() {});
              },
            )
          ],
        ),
        Expanded(
          child: FutureBuilder<List<Todo>>(
            future: DBProvider.db.getUncompletedTodos(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    Todo todo = snapshot.data[index];
                    return _buildTile(todo);
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTile(Todo todo) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      dismissThresholds: <DismissDirection, double>{
        DismissDirection.endToStart: 0.7,
      },
      onDismissed: (direction) {
        DBProvider.db.deleteTodo(todo.id);
        setState(() {});
      },
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: FractionalOffset(0.9, 0.5),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: ListTile(
        title: Text(todo.item),
        trailing: Checkbox(
          value: todo.completed,
          onChanged: (value) {
            DBProvider.db.completedOrUncompleteTask(todo);
            setState(() {});
          },
        ),
      ),
    );
  }
}

class Completed extends StatefulWidget {
  @override
  _CompletedState createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: DBProvider.db.getCompletedTodos(),
      builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Todo todo = snapshot.data[index];
              return _buildCompletedTile(todo);
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCompletedTile(Todo todo) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ListTile(
        title: Text(
          '${todo.item}',
          style: TextStyle(decoration: TextDecoration.lineThrough),
        ),
      ),
    );
  }
}