import 'dart:convert';

import 'package:crud/readStudents.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditStudent extends StatefulWidget {
  final String id;
  const EditStudent({super.key, required this.id});

  @override
  State<EditStudent> createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  void _showSuccessDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }




  Future<void>  fetchData() async {
    final apiUrl = 'http://192.168.1.100:8080/api/students/${widget.id}';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData.isNotEmpty) {
        setState(() {
          nameController.text = responseData['name'];
          surnameController.text = responseData['surname'];
        });
      }
    }
    else {
      _showErrorDialog("Error", "Something went wrong. Please try again later");
    }
  }
  Future<void>  updateData() async {
    final apiUrl = 'http://192.168.1.100:8080/api/students/${widget.id}';

    if (nameController.text.isEmpty || surnameController.text.isEmpty) {
      _showErrorDialog("Error", "Both name and surname are required");
      return;
    }

    final response = await http.put(Uri.parse(apiUrl),
    headers: <String, String> {
      'Content-Type': 'application/json; charset=UTF-8',
    },
      body: jsonEncode(<String, dynamic>{
        'name' : nameController.text,
        'surname' : surnameController.text,
      })
    );
    if (response.statusCode == 200) {
      _showSuccessDialog("Success", "Student Updated Successfully");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ReadStudents()),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ReadStudents(),
        ),
      );
    } else {
      _showErrorDialog("Error", "Something went wrong. Please try again later");
    }
  }
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Navigate to the corresponding page based on index
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ReadStudents()), // Replace with your page class
      );
    } else if (index == 1) {
       updateData();
       // Navigator.of(context).pop();

    }
  }
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.indigo[100],
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
           icon: Icon(Icons.cancel),
           label: 'Cancel'
       ),
       BottomNavigationBarItem(icon: Icon(Icons.cancel),
           label: 'Update Sudent',
       ),
      ],
        currentIndex: _selectedIndex, // State variable to track selected index
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0,),
              child: Column(
                children: [
                  const SizedBox(height: 100,
                  child: Text('Edit Student data'),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height *1,
                    decoration:const BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24, top: 20),
                      child: Column(children: [
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Name'),
                        ),
                        const SizedBox(height: 20,),
                        TextFormField(
                          controller: surnameController,
                          decoration: const InputDecoration(
                              labelText: 'Surname',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        ElevatedButton(onPressed: (){
                          updateData();
                        }, child: const Text('Update Student'))

                      ],),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
