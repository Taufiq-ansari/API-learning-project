import 'package:api/Screens/todo_list.dart';
import 'package:flutter/material.dart';

// entry level....
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: false),
      home: ToDoListPage(),
    );
  }
}
