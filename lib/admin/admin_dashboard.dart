// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_const_constructors, unused_local_variable

import 'package:dass_frontend/admin/users_view.dart';
import 'package:dass_frontend/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminDashboard extends StatefulWidget {
  static const routeName = '/AdminDashboard';

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  
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
        title: Center(child: Text('Admin Dashboard')),
        backgroundColor: Color.fromARGB(255, 76, 52, 225),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 152, 137, 252),
                    Color.fromARGB(255, 54, 30, 213)
                  ],
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UsersView(),
                            ),
                          );
                        },
                        child: Container(
                          width: 200,
                          height: 120,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/users.png',
                                height: 70,
                                width: 70,
                              ),
                              Text(
                              'Users',
                              style: GoogleFonts.acme(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Color.fromARGB(255, 80, 80, 80),
                              ),
                            ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
