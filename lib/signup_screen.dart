// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  static const routeName = '/signUp_screen';
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('This is the SignUp Screen'),
    );
  }
}
