import 'dart:convert';

import 'package:crud/studentEntity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'addStudent.dart';
import 'drawer.dart';
import 'editStudent.dart';

class ReadStudents extends StatefulWidget {
  const ReadStudents({super.key});

  @override
  State<ReadStudents> createState() => _ReadStudentsState();
}

class _ReadStudentsState extends State<ReadStudents> {
  List<Student> studentList = [];



  Future<List<Student>> fetchStudents() async {
    const apiUrl = 'http://192.168.1.100:8080/api/students';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the response body
        final List<dynamic> responseData = json.decode(response.body);

        // Map the JSON data to a list of Student objects
        final List<Student> students = responseData.map((data) {
          return Student.fromJson(data);
        }).toList();
        setState(() {
          studentList = students;
        });
        return students; // Return the list of students

      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      throw Exception('Failed to fetch students: $e');
    }
  }

  Future<void> deleteStudent(String id) async {
    final apiUrl = 'http://192.168.1.100:8080/api/students/$id';

    try {
      final response = await http.delete(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Success"),
              content: const Text("Successfully deleted student"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                )
              ],
            );
          },
        );
      }else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Something went wrong. Please try again later"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                )
              ],
            );
          },
        );
      }
    }catch (e) {

    }
  }
  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.indigo[100],
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10),
                      child: Row(
                        children: [
                          Text('Customer List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                          Spacer(),
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: TextFormField(
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.search, size: 18,),
                                contentPadding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                                border: OutlineInputBorder()
                              ),
                            ),
                          ),
                          IconButton(onPressed: (){}, icon: Icon(Icons.menu))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    height: MediaQuery.of(context).size.height *1,
                  decoration:BoxDecoration(
                      color: Colors.white70,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))
                  ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24),
                      child: Column(children: [
                         Padding(
                           padding: const EdgeInsets.only(top: 8.0),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               ElevatedButton(onPressed: (){
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(
                                     builder: (context) => AddStudent(),
                                   ),
                                 );
                               }, child: Text('Add Student')),
                             ],
                           ),
                         ),
                        const SizedBox(height: 17,),
                        Expanded(
                          child: studentList.isEmpty
                              ? const Center(child: Text('No students'))
                              :ListView.builder(
                              itemCount: studentList.length,
                              itemBuilder: (context , index) {
                                final student = studentList[index];
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditStudent(id: student.id.toString()),
                                      ),
                                    );

                                  },
                                  child: Dismissible(
                                    key: Key(studentList[index].id.toString()),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      child:  Icon(Icons.delete, color: Colors.white,),
                                    ),
                                    onDismissed: (direction){
                                      setState(() {
                                        deleteStudent(studentList[index].id.toString());
                                      });

                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [

                                          SizedBox(
                                              height: 40,
                                              width: 40,
                                              child: Image(image: AssetImage('images/a.jpg') )),
                                          SizedBox(width: 20,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                            Text(studentList[index].name),
                                            Text(studentList[index].surname),
                                          ],),
                                          Spacer(),
                                          GestureDetector(
                                              onTap: (){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) { // Provide a function body here
                                                    return AlertDialog(
                                                      title: Text("Warning"),
                                                      content: Text("Swipe left to delete!!!!", style: TextStyle(color: Colors.red),),
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
                                              },
                                              child: Icon(Icons.delete_sweep_outlined,color: Colors.red,)),
                                            SizedBox(width: 20,),

                                        ],),
                                        SizedBox(height: 20,)
                                      ],
                                    ),


                                    // ListTile(
                                    //   title: Text('Name: ${studentList[index].name}'),
                                    //   subtitle: Text('Surname: ${studentList[index].surname}'),
                                    // ),
                                  ),
                                );
                              }
                          ),
                        ),
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
