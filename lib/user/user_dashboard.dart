import 'package:flutter/material.dart';
import 'package:dass_frontend/signin_screen.dart';
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

  @override
  void initState() {
    super.initState();
    fetchQuizQuestions();
    print(widget.quizId);
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
        _logout();
      } else {
        // showToastMessage('Failed to Create User');
      }
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
        // Call your API here with the selectedOptions array
        // print(selectedOptions);
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
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: Center(
          child:
              CircularProgressIndicator(), // Display a loading indicator while fetching questions
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.name}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Question ${currentQuestionIndex + 1}:',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            questions[currentQuestionIndex],
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 16.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _selectOption(0),
                child: Text('Did not apply to me at all'),
              ),
              ElevatedButton(
                onPressed: () => _selectOption(1),
                child:
                    Text('Applied to me to some degree, or some of the time'),
              ),
              ElevatedButton(
                onPressed: () => _selectOption(2),
                child: Text(
                    'Applied to me to a considerable degree or a good part of time'),
              ),
              ElevatedButton(
                onPressed: () => _selectOption(3),
                child: Text('Applied to me very much or most of the time'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
