import 'dart:convert';

import 'package:api/Screens/addpage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  bool isLoading = false;
  List items = [];

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Text('developed by taufiq'),
      appBar: AppBar(
        title: Center(
          child: Text("ToDo List"),
        ),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchData,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: Center(
              child: Text(
                "No data found",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            child: ListView.builder(
              itemCount: items.length,
              padding: EdgeInsets.all(5.0),
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'];
                return Card(
                  child: ListTile(
                    title: Text(item['title']),
                    subtitle: Text(item['description']),
                    leading: CircleAvatar(
                      child: Text(" ${index + 1}"),
                    ),
                    trailing: PopupMenuButton(
                      onSelected: (value) {
                        if (value == 'edit') {
                          // open edit page..
                          navigateToEditdPage(item);
                        } else if (value == 'delete') {
                          //  open delete and remove the item...
                          deleteById(id);
                        }
                      },
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: Text("edit"),
                            value: 'edit',
                          ),
                          PopupMenuItem(
                            child: Text("delete"),
                            value: 'delete',
                          ),
                        ];
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text("Add ToDo"),
      ),
    );
  }

// Page Navigate function.....
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });

    fetchData();
  }

// Read the data...(edit)
  Future<void> navigateToEditdPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddToDoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchData();
  }

// API delete..
  Future<void> deleteById(String id) async {
    // delete the item...

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      // remove item from the list
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // show error message..
      showErrorMessage("unable to delete");
    }
  }

// API Get....
  Future<void> fetchData() async {
    // setState(() {
    //   isLoading = true;
    // });

    // get the data to the server
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    // print(response.statusCode);
    // print(response.body);

    // show success or fail message based on status
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } else {
// show error message
      // print("oops better luck next time");
    }
    setState(() {
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
