import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_verif/pages/MainPage.dart' show Mainpage;

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  TextEditingController MailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  Future<void> login_verif() async {
    final url = Uri.parse('http://172.22.56.52:8000/login/');
    final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': MailController.text.trim(),
      'password': PasswordController.text,
    }),
  );
    final responseBody = jsonDecode(response.body);
    print('Response body: $responseBody');

    // Status kodu kontrol etmek yerine mesajı kontrol et
    if (responseBody['message'] == 'Login successful') {
      print('✅ Login succesfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Mainpage()),
      );
    } if (responseBody['message'] == 'User not found') {
      print('User not found');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not found')),
      );
    } if (responseBody['message'] == 'Account not verified') {
      print(' Account not verified');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account not verifiedt')),
      );
    } if (responseBody['message'] == 'Invalid password') {
      print('Invalid password');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid password')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login page"),
            TextField(
              controller: MailController,
              decoration: InputDecoration(
                hint: Text("Write your mail")
              ),
            ),
            TextField(
              controller: PasswordController,
              decoration: InputDecoration(
                hint: Text("Write your password")
              ),
            ),
            ElevatedButton(onPressed: (){
              login_verif();
            }, child: Text("Login"))
          ],
        ),
      ),
    );
  }
}