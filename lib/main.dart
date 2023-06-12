import 'package:dass_frontend/admin/admin_dashboard.dart';
import 'package:dass_frontend/admin/create_user.dart';
import 'package:dass_frontend/signin_screen.dart';
import 'package:dass_frontend/signup_screen.dart';
import 'package:dass_frontend/splash_screen.dart';
import 'package:dass_frontend/user/user_dashboard.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: splashScreen(),
      routes: {
        SignUpPage.routeName: (ctx) => SignUpPage(),
        SigninScreen.routeName: (ctx) => SigninScreen(),
        AdminDashboard.routeName: (ctx) => AdminDashboard(),
        CreateUser.routeName: (ctx) => CreateUser(),
        UserDashboard.routeName: (ctx) => UserDashboard(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
