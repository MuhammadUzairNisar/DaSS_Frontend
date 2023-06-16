// ignore_for_file: prefer_const_constructors, avoid_print, depend_on_referenced_packages, non_constant_identifier_names, use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously

import 'package:dass_frontend/admin/congratulations_screen.dart';
import 'package:flutter/material.dart';
import 'package:dass_frontend/views/signin_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDashboard extends StatefulWidget {
  static const routeName = '/UserDashboard';
  final int? quizId;
  final String? name;
  final int? quiz_attempt_id;

  const UserDashboard({required this.quizId, this.name, this.quiz_attempt_id});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  List<String> questions = [];
  List<int> selectedOptions = [];
  int currentQuestionIndex = 0;

  var textOption1 = '';
  var textOption2 = '';
  var textOption3 = '';
  var textOption4 = '';

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
    print(widget.quizId);
    if (widget.quizId == 1 || widget.quizId == 2) {
      textOption1 = 'Did not apply to me at all';
      textOption2 = 'Applied to me to some degree, or some of the time';
      textOption3 =
          'Applied to me to a considerable degree or a good part of time';
      textOption4 = 'Applied to me very much or most of the time';
    } else if (widget.quizId == 3 || widget.quizId == 4) {
      textOption1 = 'کبھی نہیں';
      textOption2 = 'کبھی کبھار';
      textOption3 = 'زیادہ تر وقت';
      textOption4 = 'ہر وقت';
    }
  }

  Future<void> fetchQuizQuestions() async {
    final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/get_quiz_questions/${widget.quizId}'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final List<dynamic> questionsData = responseData['quiz_questions'];
      final List<String> fetchedQuestions = questionsData
          .map((question) => question['question'] as String)
          .toList();

      setState(() {
        questions = fetchedQuestions;
      });
    } else {
      print('Failed to fetch quiz questions. Error: ${response.reasonPhrase}');
    }
  }

  Future<void> postQuiz() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/submit_quiz');
    final headers = {'Content-Type': 'application/json'};

    final body = json.encode({
      'quiz_attempt_id': widget.quiz_attempt_id,
      'quiz_id': widget.quizId,
      'selected_options': selectedOptions,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(responseData);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CongratulationScreen()),
        );
      } else {}
    } catch (e) {
      print('An error occurred while creating user');
    }
  }

  void _logout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SigninScreen.routeName,
      (route) => false,
    );
  }

  void _selectOption(int option) {
    setState(() {
      selectedOptions.add(option);
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
      } else {
        postQuiz();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.name}'),
          backgroundColor: Color.fromARGB(255, 76, 52, 225),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Center(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        appBar: AppBar(
          title: Center(
              child: Text(
            '${widget.name}',
          )),
          backgroundColor: Color.fromARGB(255, 76, 52, 225),
          automaticallyImplyLeading: false,
        ),
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Text(
                'Question ${currentQuestionIndex + 1}',
                style: GoogleFonts.lobster(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: Color.fromARGB(255, 80, 80, 80),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Text(
                questions[currentQuestionIndex],
                style: GoogleFonts.firaSansCondensed(
                  fontWeight: FontWeight.w500,
                  fontSize: 22,
                  color: Color.fromARGB(255, 112, 112, 112),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(250, 50, 250, 0),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _selectOption(0),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      textOption1,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 76, 52, 225),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.fromLTRB(250, 0, 250, 0),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _selectOption(1),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      textOption2,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 76, 52, 225),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.fromLTRB(250, 0, 250, 0),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _selectOption(2),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      textOption3,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 76, 52, 225),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.fromLTRB(250, 0, 250, 0),
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _selectOption(3),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      textOption4,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 76, 52, 225),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
