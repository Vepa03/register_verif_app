import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
        backgroundColor: Colors.amber,
      ),
      body: Center(
        child: ElevatedButton(onPressed: (){
        }, child: Text("Profil")),
      ),
    );
  }
}