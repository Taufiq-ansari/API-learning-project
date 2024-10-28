import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToDoPage extends StatefulWidget {
  final Map? todo;
  const AddToDoPage({super.key, this.todo});

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];

      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            isEdit ? "Edit Todo" : "AddToDo",
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: "title",
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextField(
            controller: descriptionController,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Description',
            ),
            maxLines: 8,
            minLines: 5,
          ),
          SizedBox(
            height: 10.0,
          ),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Text(
              isEdit ? "Update" : "Submit",
            ),
          ),
        ],
      ),
    );
  }

  // Put Api...
  Future<void> updateData() async {
    // get data from form

    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    // submit  update the data to the server
    final todo = widget.todo;
    if (todo == null) {
      print("you can not call update without todo data");
      return;
    }
    final id = todo['_id'];
    final url = "https://api.nstack.in/v1/todos/$id";
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    // print(response.body);
    // print(response.statusCode);

    // show success or fail message based on status
    if (response.statusCode == 200) {
      showSuccessMessage("updation Success");
      // print("success");
    } else {
      showErrorMessage("updation failed");
      // print("creation failed");
    }
  }

// API  Post.....
  Future<void> submitData() async {
    // get data from form

    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    // submit the data to the server
    final url = "https://api.nstack.in/v1/todos";
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    // print(response.body);
    // print(response.statusCode);

    // show success or fail message based on status
    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      showSuccessMessage("Creation Success");
      // print("success");
    } else {
      showErrorMessage("Creation failed");
      // print("creation failed");
    }
  }

// show success message function...
  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// show error message function...
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
