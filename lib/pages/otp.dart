import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_verif/pages/MainPage.dart';
import 'package:lottie/lottie.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> verifyOtp() async {
  final url = Uri.parse('http://192.168.100.33:8000/verify/');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'email': widget.email,
      'otp': otpController.text.trim(),
    }),
  );

  final responseBody = jsonDecode(response.body);
  print('Response body: $responseBody');

  // Status kodu kontrol etmek yerine mesajı kontrol et
  if (responseBody['message'] == 'OTP verified') {
    print('✅ OTP verification successful');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Mainpage()),
    );
  } else {
    print('❌ OTP verification failed');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP incorrect')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width,
                    height: height*0.3,
                    child: Lottie.asset("lib/assets/lottie/signup.json")),
                  SizedBox(height: 10.0,),
                  Text("Enter OTP sent to ${widget.email}", style: TextStyle(fontSize: width*0.06, color: Colors.black, fontWeight: FontWeight.bold),),
                  SizedBox(height: 10.0,),
                  TextFormField(
                    controller: otpController,
                    validator: (value){
                      if (value == null || value.isEmpty) {
                        return "OTP code is required";
                      } 
                        return null;
                    },
                    decoration: InputDecoration(
                      prefix: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Icon(Icons.key),
                      ),
                      label: Text("OTP code"),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10.0,),
                  SizedBox(
                    width: width,
                    height: height*0.05,
                    child: ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState!.validate()){
                          verifyOtp(); 
                        }
                      },
                      child: Text("Verify", style: TextStyle(color: Colors.white, fontSize: width*0.06, fontWeight: FontWeight.bold),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
