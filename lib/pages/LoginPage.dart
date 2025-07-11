import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_verif/pages/HomePage.dart';
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
              Text("Login to Kitap", style: TextStyle(fontSize: width*0.07, color: Colors.black, fontWeight: FontWeight.bold),),
              SizedBox(height: 10.0,),
              TextFormField(
                controller: MailController,
                decoration: InputDecoration(
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Icon(Icons.mail),
                  ),
                  label: Text("Enter your Mail",),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return "Mail is required";
                  }
                  return null;
                },
              ),
              SizedBox(height:10),
              TextFormField(
                controller: PasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Icon(Icons.key),
                  ),
                  label: Text("Enter your Password"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                validator: (value){
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  return null;
                },
          
              ),
              SizedBox(height: 10.0),
              Text.rich(
                TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(fontSize: width*0.04, color: Colors.black),
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
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              SizedBox(
                width: width,
                height: height*0.05,
                child: ElevatedButton(onPressed: (){
                  if(_formKey.currentState!.validate()){
                      login_verif(); 
                    }
                }, child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: width*0.06)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black
                ),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}