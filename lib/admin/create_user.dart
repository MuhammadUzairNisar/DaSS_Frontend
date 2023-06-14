// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_const_constructors, prefer_final_fields, unused_local_variable, empty_catches

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreateUser extends StatefulWidget {
  static const routeName = '/CreateUser';
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController typeController = TextEditingController();

  List<String> dropdownItems = []; // List to store dropdown items
  String selectedDropdownItem = ''; // Currently selected dropdown item
  String? selectedQuizId;
  List<Map<String, dynamic>> quizList = [];

  @override
  void initState() {
    super.initState();
    fetchQuizzes(); // Call the GET API to fetch dropdown items
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    typeController.dispose();
    super.dispose();
  }

  Future<void> fetchQuizzes() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/get_quizzes');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> quizzesData = responseData['quizzes'];
        setState(() {
          quizList = quizzesData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Failed to fetch quizzes. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred. Error: $e');
    }
  }

  Future<void> addUser() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/add_user');
    final headers = {'Content-Type': 'application/json'};

    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final type = typeController.text;

    final body = json.encode({
      'name': name,
      'email': email,
      'password': password,
      'type': type,
      'quiz_id': selectedQuizId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // showToastMessage('User Created Successfully');
      } else {
        // showToastMessage('Failed to Create User');
      }
    } catch (e) {
      // showToastMessage('An error occurred while creating user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            DropdownButtonFormField<String>(
              value: selectedQuizId,
              items: quizList.map((quiz) {
                return DropdownMenuItem<String>(
                  value: quiz['id'].toString(),
                  child: Text(quiz['quiz_name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedQuizId = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Quiz',
              ),
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                addUser();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showToastMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
