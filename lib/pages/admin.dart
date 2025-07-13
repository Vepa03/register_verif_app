import 'package:flutter/material.dart';

class Admin extends StatelessWidget {
  final String username;
  const Admin({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text(username),
    );
  }
}