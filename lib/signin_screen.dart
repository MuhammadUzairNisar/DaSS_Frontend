// ignore_for_file: unused_local_variable, prefer_const_constructors, avoid_print, prefer_const_declarations, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';

import 'package:dass_frontend/admin/admin_dashboard.dart';
import 'package:dass_frontend/user/user_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class SigninScreen extends StatefulWidget {
  static const routeName = '/signIn_screen';

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final url = 'http://127.0.0.1:8000/api/login';
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final user = responseData['user'];
        final userType = user['type'];
        final quizId = user['quiz_id'];
        final name = user['name'];
        final quiz_attempt_id = responseData['quiz_attempt_id'];

        // showToastMessage('Sign-in Successful');

        if (userType == 'admin') {
          Navigator.pushNamed(context, AdminDashboard.routeName);
        } else if (userType == 'user') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserDashboard(
                      quizId: quizId,
                      name: name,
                      quiz_attempt_id: quiz_attempt_id,
                    )),
          );
          // print(quizId);
        } else {
          // showToastMessage('Invalid User Type');
        }
      } else {
        // showToastMessage('Sign-in Failed');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Sign In'),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _passwordController,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
          ],
        ),
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
