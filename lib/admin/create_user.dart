// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_const_constructors, prefer_final_fields, unused_local_variable, empty_catches, depend_on_referenced_packages, avoid_print, use_build_context_synchronously, sort_child_properties_last

import 'dart:convert';
import 'package:dass_frontend/admin/users_view.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

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

  List<String> dropdownItems = [];
  String selectedDropdownItem = '';
  String? selectedQuizId;
  List<Map<String, dynamic>> quizList = [];

  @override
  void initState() {
    super.initState();
    fetchQuizzes();
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
        Navigator.pushReplacementNamed(context, UsersView.routeName);
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
      backgroundColor: Color.fromARGB(255, 217, 211, 255),
      appBar: AppBar(
        title: Text('Create User'),
        backgroundColor: Color.fromARGB(255, 76, 52, 225),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 220, 0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 220, 0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 220, 0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 220, 0),
              child: DropdownButtonFormField<String>(
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
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                addUser();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 76, 52, 225),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
