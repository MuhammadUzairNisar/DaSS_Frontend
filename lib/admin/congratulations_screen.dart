// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'dart:async';
import 'package:dass_frontend/views/signin_screen.dart';
import 'package:flutter/material.dart';

class CongratulationScreen extends StatefulWidget {
  @override
  _CongratulationScreenState createState() => _CongratulationScreenState();
}

class _CongratulationScreenState extends State<CongratulationScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacementNamed(SigninScreen.routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Thank You!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
