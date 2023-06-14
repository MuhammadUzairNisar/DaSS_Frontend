// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors, unused_local_variable

import 'package:dass_frontend/admin/create_user.dart';
import 'package:dass_frontend/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = '/AdminDashboard';

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/get_users');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> usersData = responseData['users'];
        setState(() {
          users = usersData.map((userJson) => User.fromJson(userJson)).toList();
        });
      } else {
        print('Failed to fetch users. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred. Error: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/delete_user/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // showToastMessage('User Deleted Successfully');
        fetchUsers();
      } else {
        // showToastMessage('Failed to Delete User');
        print('Failed to delete user. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred while deleting user. Error: $e');
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SigninScreen.routeName,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView(
        children: [
          Center(
            child: ElevatedButton(
              child: Text('Add User'),
              onPressed: () {
                Navigator.pushNamed(context, CreateUser.routeName);
              },
            ),
          ),
          DataTable(
            columns: const <DataColumn>[
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Delete')),
            ],
            rows: users.map((user) {
              return DataRow(
                cells: [
                  DataCell(Text(user.name)),
                  DataCell(Text(user.email)),
                  DataCell(Text(user.type)),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteUser(user.id);
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void showToastMessage(String? msg) {
    var toast = Fluttertoast.showToast(
      msg: msg!,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String type;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
