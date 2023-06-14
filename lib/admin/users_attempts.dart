// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserAttempts extends StatefulWidget {
  static const routeName = '/UserAttempts';

  @override
  _UserAttemptsState createState() => _UserAttemptsState();
}

class _UserAttemptsState extends State<UserAttempts> {
  List<String> users = []; // List to store the users fetched from API
 String? selectedUser; // Currently selected user from dropdown

  @override
  void initState() {
    super.initState();
    fetchUsers(); // Fetch users when the state is initialized
  }

  Future<void> fetchUsers() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/get_users'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final usersList = List<String>.from(data['users']);
    setState(() {
      users = usersList;
    });
  } else {
    // Handle API error or no response
    print('Failed to fetch users');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 211, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 52, 225),
        title: Text('User Attempts'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<String>(
              value: selectedUser,
              onChanged: (newValue) {
                setState(() {
                  selectedUser = newValue!;
                });
              },
              items: users.map<DropdownMenuItem<String>>((String user) {
                return DropdownMenuItem<String>(
                  value: user,
                  child: Text(user),
                );
              }).toList(),
              hint: Text('Select User'),
            ),
          ],
        ),
      ),
    );
  }
}

