import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_verif/pages/LoginPage.dart';
import 'package:flutter/gestures.dart';
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
    final url = Uri.parse('http://172.22.56.52:8000/register/');

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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Register to Kitap', style: TextStyle(fontSize: width*0.07, color: Colors.black, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(fontSize: 20, color: Colors.black),
                controller: MailController,
                decoration: InputDecoration(
                  label: Text("Enter your mail"),
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Icon(Icons.mail),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return "Mail is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                style: TextStyle(fontSize: 20, color: Colors.black),
                controller: PasswordController,
                obscureText: true, 
                decoration: InputDecoration(
                  label: Text("Enter your password"),
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Icon(Icons.key),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                ),
                validator: (value){
                  if (value == null || value.isEmpty){
                    return "Password is required";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: 'Already registered? ',
                  style: TextStyle(fontSize: width*0.04, color: Colors.black, fontWeight: FontWeight.w300),
                  children: [
                    TextSpan(
                      text: 'Click here',
                      style: TextStyle(
                        fontSize: width*0.04,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Loginpage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: width,
                height: height*0.05,
                child: ElevatedButton(
                  onPressed: () {
                    if(_formKey.currentState!.validate()){
                      registerUser(); 
                    }
                  },
                  child: Text("Register", style: TextStyle(fontSize: width*0.06, color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
