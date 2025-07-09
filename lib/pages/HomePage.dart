import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController MailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fill Your Name', style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),),
            TextField(
              style: TextStyle(fontSize: 20, color: Colors.black),
              controller: MailController,
              decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your mail', hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            TextField(
              style: TextStyle(fontSize: 20, color: Colors.black),
              controller: PasswordController,
              decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter your password', hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: (){}, 
              child: Text("Register", style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)))
        
        
          ],
        ),
      ),
    );
  }
}