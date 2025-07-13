import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_verif/pages/MainPage.dart';
import 'package:login_verif/pages/admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  File? _imageFile;

  final _formKey = GlobalKey<FormState>();

  TextEditingController UserNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedImage();
  }
  // Kayıtlı fotoğraf yolunu yükle
  Future<void> _loadSavedImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      setState(() {
        _imageFile = File(imagePath);
      });
    }
  }

  // Fotoğraf seç ve kaydet
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File image = File(pickedFile.path);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', image.path);

      setState(() {
        _imageFile = image;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Profil")),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onDoubleTap: (){
                      _pickImage();
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                      backgroundColor: Colors.grey[300],
                      child: _imageFile == null
                          ? const Icon(Icons.upload, size: 70, color: Colors.white)
                          : null,
                    ),
                  ),
                  TextFormField(
                    controller: UserNameController,
                    decoration: InputDecoration(
                      label: Text("Username"),
                      prefix: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                      validator: (value){
                        if (value == null || value.isEmpty){
                          return "Password is required";
                        }
                        return null;
                      },
                  ),
                  ElevatedButton(
                    onPressed: () {
                        if(_formKey.currentState!.validate()){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Admin(username: UserNameController.text))); 
                        }
                      }, child: Text("Next"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
