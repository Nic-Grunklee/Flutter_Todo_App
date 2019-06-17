import 'dart:convert';

class Todo {
  int id;
  String item;
  bool completed;

  Todo({
    this.id,
    this.item,
    this.completed
  });

  factory Todo.fromMap(Map<String, dynamic> json) =>  new Todo(
    id: json['id'],
    item: json['item'],
    completed: json['completed']
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'item': item,
    'completed': completed
  };
}