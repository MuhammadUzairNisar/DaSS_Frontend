// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_const_constructors, prefer_final_fields

import 'package:dass_frontend/signin_screen.dart';
import 'package:flutter/material.dart';

class UserDashboard extends StatefulWidget {
  static const routeName = '/UserDashboard';
  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
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
        title: Text('User Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Text('This is the User Dashboard'),
    );
  }
}

