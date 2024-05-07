import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:crud/footer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

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

  Future<void> registerUser() async {
    String apiUrl =
        'http://192.168.1.100:8080/register/user'; // Replace with your actual API URL
    Uri url = Uri.parse(apiUrl);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> userData = {
      'username': studentNameController.text,
      'password': passwordController.text,
    };

    String requestBody = json.encode(userData);

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        // Registration successful
        showOkAlertDialog(
            context: context,
            title: "Yeeey",
            message: "User Registerd",
            okLabel: "OK");
        print('User registered successfully');
        // Handle further actions like navigation or showing a success message
      } else {
        // Registration failed
        print('Failed to register user');
        // Handle error, e.g., show error message to user
      }
    } catch (e) {
      print('Error: $e');
      // Handle any exceptions, e.g., show error message to user
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Register",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        height: 140,
                        width: MediaQuery.of(context).size.width,
                        child: Image.asset(fit: BoxFit.cover, "images/pic.jpg"),
                      ),
                      Positioned(
                        top: 100,
                        child: SizedBox(
                          height: 100,
                          child:
                              Image.asset(fit: BoxFit.cover, "images/hit.png"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          color: Colors.grey,
                          height: h * 0.03,
                          width: 1,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: w * 0.7,
                          child: TextField(
                            controller: studentNameController,
                            decoration: InputDecoration(
                              labelText: "Enter your registration number",
                              labelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .orange), // Change color as desired
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.lock_open,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          color: Colors.grey,
                          height: h * 0.03,
                          width: 1,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: w * 0.7,
                          child: TextField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: "Enter your password",
                              labelStyle: TextStyle(color: Colors.grey),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .orange), // Change color as desired
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  StatefulBuilder(
                    builder: (context, setState) => SizedBox(
                      width: h * 0.4,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color?>(Colors.indigo),
                          foregroundColor:
                              MaterialStateProperty.all<Color?>(Colors.white),
                        ),
                        onPressed: () async {
                          setState(() =>
                              isLoading = true); // Show progress indicator
                          await Future.delayed(const Duration(milliseconds: 0));
                          registerUser();
                          setState(() => isLoading = false);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              isLoading
                                  ? SizedBox(
                                      height: h * 0.03,
                                      width: h * 0.03,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    )
                                  : Text("Register Student"),
                              Spacer(),
                              Icon(
                                Icons.app_registration,
                                color: Colors.white,
                                size: h * 0.03,
                              ),
                            ],
                          ),
                        ),
                      ),
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
