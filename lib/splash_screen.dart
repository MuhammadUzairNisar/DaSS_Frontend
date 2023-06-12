// ignore_for_file: prefer_const_constructors, camel_case_types, use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:async';
import 'package:dass_frontend/signup_screen.dart';
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
        () => Navigator.of(context).pushNamed(SignUpPage.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: const [
          Color.fromARGB(255, 255, 255, 255),
          Color.fromARGB(255, 169, 159, 224),
          Color.fromARGB(255, 122, 110, 204),
          Color.fromARGB(255, 98, 81, 214),
          Color.fromARGB(255, 70, 50, 197),
          Color.fromARGB(255, 52, 25, 221),
        ],
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image.asset(
          //   'assets/techlogo.png',
          //   height: 400,
          //   width: 300,
          // ),
        ],
      ),
    );
  }
}
