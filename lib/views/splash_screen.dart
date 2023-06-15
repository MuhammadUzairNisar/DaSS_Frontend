// ignore_for_file: prefer_const_constructors, camel_case_types, use_key_in_widget_constructors, library_private_types_in_public_api, unused_import, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:dass_frontend/views/signin_screen.dart';
import 'package:flutter/material.dart';

class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushNamed(SigninScreen.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: const [
          Color.fromARGB(255, 211, 204, 255),
          Color.fromARGB(255, 122, 105, 239),
          Color.fromARGB(255, 110, 92, 230),
          Color.fromARGB(255, 76, 52, 225),
          Color.fromARGB(255, 59, 40, 185),
          Color.fromARGB(255, 28, 4, 187),
        ],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/quiz_system.png',
            height: 400,
            width: 300,
          ),
        ],
      ),
    );
  }
}
