import 'package:crud/editStudent.dart';
import 'package:crud/readStudents.dart';
import 'package:flutter/material.dart';

import 'addStudent.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text("Student CRUD using SpringBoot and MySQL"),
          ),
          ListTile(
            title: Text('Home'),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReadStudents(),
                ),
              );
            },
          ),
          ListTile(
            title: Text('Add data'),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStudent(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
