import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_verif/pages/MainPage.dart';

class OtpScreen extends StatefulWidget {
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController otpController = TextEditingController();

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
    return Scaffold(
      appBar: AppBar(title: const Text("Verify OTP")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Enter OTP sent to ${widget.email}"),
            TextField(
              controller: otpController,
              decoration: const InputDecoration(hintText: "OTP"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: verifyOtp,
              child: const Text("Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
