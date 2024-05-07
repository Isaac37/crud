import 'dart:convert';

import 'package:crud/readStudents.dart';
import 'package:crud/studentEntity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  Future<void> addStudent() async {
    final String apiUrl = 'http://192.168.1.100:8080/api/students';

    if (nameController.text.isEmpty || surnameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) { // Provide a function body here
          return AlertDialog(
            title: Text("Error"),
            content: Text("Both name and surname are required"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
      return;
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': nameController.text.trim(),
        'surname': surnameController.text.trim()
      }),
    );

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);

      var student = Student.fromJson(responseData);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Student Added Successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  nameController.clear();
                  surnameController.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadStudents(),
                    ),
                  );
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
    } else if (response.statusCode == 409) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Student with the same name and surname already exists"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
    }

    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Failed to add student. Please try again later"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100,
                  child: Text("add data to db using springboot & flutter"),),
                  SizedBox(height: 100,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Name"),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: surnameController,
                      decoration: InputDecoration(labelText: "Surame"),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(onPressed: (){addStudent();}, child:  Text("Add Student"),
                  ),],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


