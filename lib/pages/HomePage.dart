import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_verif/pages/otp.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController MailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();

  Future<void> registerUser() async {
    final url = Uri.parse('http://192.168.100.33:8000/register/');

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

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('✅ Registration successful!');
      print('Response: ${response.body}');
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> OtpScreen(email: MailController.text.trim())));
      // Örneğin: OTP ekranına geçiş
    } else {
      print('❌ Registration failed.');
      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');
      // Hata mesajını kullanıcıya göstermek için snackbar vs. yapabilirsin
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
            Text('Fill Your Name', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(fontSize: 20, color: Colors.black),
              controller: MailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your mail',
                hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(fontSize: 20, color: Colors.black),
              controller: PasswordController,
              obscureText: true,  // 🔒 Şifre gizli olsun
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your password',
                hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                registerUser();  // 🔔 Register butonu artık çalışıyor
              },
              child: Text("Register", style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
