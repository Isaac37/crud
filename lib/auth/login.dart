import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../footer.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void _handleLogin() async {
    // Validate form data (username and password)
    if (studentNameController.text.isEmpty || passwordController.text.isEmpty) {
      showOkAlertDialog(
          context: context,
          title: "Alert",
          message: "Please fill in all the fields",
          okLabel: "OK");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            "http://192.168.1.100:8080/login"), // Replace with your actual URL
        body: {
          "username": studentNameController.text,
          "password": passwordController.text,
        },
      );
      // Handle successful response based on status code and response data
      if (response.statusCode == 200) {
        // Handle successful login (e.g., navigate to a different screen)
        print("Login successful!");
        showOkAlertDialog(
            context: context,
            title: "Login ",
            message: "Successful",
            okLabel: "OK");
      } else {
        showOkAlertDialog(
            context: context,
            title: "Alert",
            message: "Login Unsuccessful Please try again!!!",
            okLabel: "OK");
      }
    } catch (error) {
      // Handle network errors or other exceptions
      print("Error logging in: $error");
      showOkAlertDialog(
          context: context,
          title: "Error",
          message:
              "Login failed. Please check your network connection or try again later.",
          okLabel: "OK");
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
                    "Log In",
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
                  SizedBox(
                    width: h * 0.4,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color?>(Colors.indigo),
                        foregroundColor:
                            MaterialStateProperty.all<Color?>(Colors.white),
                      ),
                      onPressed: () {
                        _handleLogin();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("Login"),
                            Spacer(),
                            Icon(
                              Icons.login,
                              color: Colors.white,
                              size: h * 0.03,
                            ),
                          ],
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
