import 'dart:convert';
import 'package:dass_frontend/admin/users_view.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateUser extends StatefulWidget {
  static const routeName = '/CreateUser';

  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cnicController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  List<String> dropdownItems = [];
  String selectedDropdownItem = '';
  String? selectedQuizId;
  List<Map<String, dynamic>> quizList = [];

  @override
  void initState() {
    super.initState();
    fetchQuizzes();
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    cnicController.dispose();
    typeController.dispose();
    dobController.dispose();
    super.dispose();
  }

  Future<void> fetchQuizzes() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/get_quizzes');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final List<dynamic> quizzesData = responseData['quizzes'];
        setState(() {
          quizList = quizzesData.cast<Map<String, dynamic>>();
        });
      } else {
        print('Failed to fetch quizzes. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('An error occurred. Error: $e');
    }
  }

  Future<void> addUser() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/add_user');
    final headers = {'Content-Type': 'application/json'};

    final name = nameController.text;
    final password = passwordController.text;
    final cnic = cnicController.text;
    final type = typeController.text;
    final dob = dobController.text;

    final body = json.encode({
      'name': name,
      'pin_number': password,
      'cnic': cnic,
      'type': type,
      'quiz_id': selectedQuizId,
      'birth_date': dob,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, UsersView.routeName);
      } else {
        // showToastMessage('Failed to Create User');
      }
    } catch (e) {
      // showToastMessage('An error occurred while creating user');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      dobController.text = formattedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 217, 211, 255),
      appBar: AppBar(
        title: Text('Create User'),
        backgroundColor: Color.fromARGB(255, 76, 52, 225),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 220, 0),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 220, 0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(5),
                ],
                decoration: InputDecoration(
                  labelText: 'Enter PIN',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 220, 0),
              child: TextFormField(
                controller: cnicController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(13),
                ],
                decoration: InputDecoration(
                  labelText: 'Enter CNIC Number (without dashes)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 220, 0),
              child: DropdownButtonFormField<String>(
                value: selectedQuizId,
                items: quizList.map((quiz) {
                  return DropdownMenuItem<String>(
                    value: quiz['id'].toString(),
                    child: Text(quiz['quiz_name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedQuizId = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Quiz',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(220, 0, 220, 0),
              child: GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: dobController,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                addUser();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 76, 52, 225),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
