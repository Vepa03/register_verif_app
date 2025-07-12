import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_verif/model/category_model.dart' show category;

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainPageState();
}

class _MainPageState extends State<Mainpage> with TickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<category>> futureCategories;

  @override
  void initState() {
    super.initState();
    futureCategories = fetchCategories();
  }

  Future<List<category>> fetchCategories() async {
    final response = await http.get(Uri.parse('http://192.168.100.33:8000/api/category/'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((cat) => category.fromJson(cat)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<category>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (snapshot.hasData) {
          final categories = snapshot.data!;
          _tabController = TabController(length: categories.length, vsync: this);

          return Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Icon(Icons.person_outline),
                )
              ],
              automaticallyImplyLeading: false,
              title: const Text('Kitaplar'),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true, 
                tabs: categories.map((cat) => Tab(text: cat.name ?? '')).toList(),
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: categories.map((cat) {
                return Center(child: Text("Content for ${cat.name}"));
              }).toList(),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('No categories found')),
          );
        }
      },
    );
  }
}
