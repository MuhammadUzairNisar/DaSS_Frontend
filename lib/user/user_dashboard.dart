// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, unused_field, prefer_const_constructors, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:dass_frontend/signin_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDashboard extends StatefulWidget {
  static const routeName = '/UserDashboard';
  final int? quizId;
  const UserDashboard({required this.quizId});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  List<String> questions = [];
  
  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
    print(widget.quizId);
  }

  Future<void> fetchQuizQuestions() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/get_quiz_questions/${widget.quizId}'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> questionsData = responseData['questions'];
      final List<String> fetchedQuestions = questionsData.map((question) => question['question'] as String).toList();

      setState(() {
        questions = fetchedQuestions;
      });
    } else {
      print('Failed to fetch quiz questions. Error: ${response.reasonPhrase}');
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
        title: Text('User Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(questions[index]),
          );
        },
      ),
    );
  }
}
