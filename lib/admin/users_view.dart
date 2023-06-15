// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors, unused_local_variable, use_build_context_synchronously, avoid_unnecessary_containers, unused_element, sort_child_properties_last

import 'package:dass_frontend/admin/create_user.dart';
import 'package:dass_frontend/views/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class UsersView extends StatefulWidget {
  static const routeName = '/UsersView';

  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  List<User> users = [];
  final TextEditingController newPinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  void dispose() {
    newPinController.dispose();
    super.dispose();
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

  Future<void> attemptsCheck(int id) async {
    final url =
        Uri.parse('http://127.0.0.1:8000/api/getQuizAttemptsbyUserId/$id');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<dynamic> quizAttempts = jsonData['quiz_attempts'];

        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: ListView.builder(
                itemCount: quizAttempts.length,
                itemBuilder: (BuildContext context, int index) {
                  final attempt = quizAttempts[index];
                  return ListTile(
                    title: Text('Quiz Id: ${attempt['quiz_id']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Anxiety: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              (attempt['anxiety_level'] != null &&
                                      attempt['anxiety_level'] < 3)
                                  ? 'Normal'
                                  : (attempt['anxiety_level'] != null &&
                                              attempt['anxiety_level'] == 4 ||
                                          attempt['anxiety_level'] == 5)
                                      ? 'Mild'
                                      : (attempt['anxiety_level'] != null &&
                                                  attempt['anxiety_level'] ==
                                                      6 ||
                                              attempt['anxiety_level'] == 7)
                                          ? 'Moderate'
                                          : (attempt['anxiety_level'] != null &&
                                                      attempt['anxiety_level'] ==
                                                          8 ||
                                                  attempt['anxiety_level'] == 9)
                                              ? 'Severe'
                                              : (attempt['anxiety_level'] !=
                                                          null &&
                                                      attempt['anxiety_level'] >=
                                                          10)
                                                  ? 'Extremely Severe'
                                                  : 'No Data Available',
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Depression: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text((attempt['depression_level'] != null &&
                                    attempt['depression_level'] < 4)
                                ? 'Normal'
                                : (attempt['depression_level'] != null &&
                                            attempt['depression_level'] == 5 ||
                                        attempt['depression_level'] == 6)
                                    ? 'Mild'
                                    : (attempt['depression_level'] != null &&
                                                attempt['depression_level'] ==
                                                    7 ||
                                            attempt['depression_level'] == 8 ||
                                            attempt['depression_level'] == 9 ||
                                            attempt['depression_level'] == 10)
                                        ? 'Moderate'
                                        : (attempt['depression_level'] !=
                                                        null &&
                                                    attempt['depression_level'] ==
                                                        11 ||
                                                attempt['depression_level'] ==
                                                    12 ||
                                                attempt['depression_level'] ==
                                                    13)
                                            ? 'Severe'
                                            : (attempt['depression_level'] !=
                                                        null &&
                                                    attempt['depression_level'] >=
                                                        14)
                                                ? 'Extremely Severe'
                                                : 'No Data Available'),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Stress: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Text((attempt['stress_level'] != null &&
                                    attempt['stress_level'] < 7)
                                ? 'Normal'
                                : (attempt['stress_level'] != null &&
                                            attempt['stress_level'] == 8 ||
                                        attempt['stress_level'] == 9)
                                    ? 'Mild'
                                    : (attempt['stress_level'] != null &&
                                                attempt['stress_level'] == 10 ||
                                            attempt['stress_level'] == 11 ||
                                            attempt['stress_level'] == 12)
                                        ? 'Moderate'
                                        : (attempt['stress_level'] != null &&
                                                    attempt['stress_level'] ==
                                                        13 ||
                                                attempt['stress_level'] == 14 ||
                                                attempt['stress_level'] == 15 ||
                                                attempt['stress_level'] == 16)
                                            ? 'Severe'
                                            : (attempt['stress_level'] !=
                                                        null &&
                                                    attempt['stress_level'] >=
                                                        17)
                                                ? 'Extremely Severe'
                                                : 'No Data Available'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Text(
                      'Attempt Date: ${attempt['created_at'].substring(0, 10)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      } else {
        print(
            'Failed to retrieve quiz attempts. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred while retrieving quiz attempts. Error: $e');
    }
  }

  Future<void> changePin(int id, String newPin) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/change_pin_number');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'user_id': id,
          'pin_number': newPin,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        showToastMessage('Pin Number Changed Successfully');
        fetchUsers();
      } else {
        showToastMessage('Failed to Change Pin Number');
        print('Failed to change pin number. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred while changing pin number. Error: $e');
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
      backgroundColor: Color.fromARGB(255, 217, 211, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 76, 52, 225),
        title: Text('Users'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: ListView(
              children: [
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('CNIC')),
                    DataColumn(label: Text('Type')),
                    DataColumn(label: Text('Attempts')),
                    DataColumn(label: Text('Change PIN')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: users.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(Text(user.name)),
                        DataCell(Text(user.cnic)),
                        DataCell(Text(user.type)),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.assessment),
                            color: Colors.blue,
                            onPressed: () {
                              attemptsCheck(user.id);
                            },
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.pin_rounded),
                            color: Colors.blue,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Change PIN'),
                                    content: TextFormField(
                                      controller: newPinController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter new PIN',
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),
                                        LengthLimitingTextInputFormatter(5),
                                      ],
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text('Save'),
                                        onPressed: () {
                                          changePin(
                                              user.id, newPinController.text);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete User'),
                                    content: Text(
                                        'Are you sure you want to delete this user?'),
                                    actions: [
                                      ElevatedButton(
                                        child: Text('No'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ElevatedButton(
                                        child: Text('Yes'),
                                        onPressed: () {
                                          deleteUser(user.id);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/default_avatar.png'),
                    radius: 30,
                  ),
                  Text(
                    'Welcome, Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 76, 52, 225),
              ),
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Create User'),
              onTap: () {
                Navigator.pushNamed(context, CreateUser.routeName);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

class User {
  final int id;
  final String name;
  final String cnic;
  final String type;

  User({
    required this.id,
    required this.name,
    required this.cnic,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      cnic: json['cnic'],
      type: json['type'],
    );
  }
}
