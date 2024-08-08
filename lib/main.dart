import 'dart:convert';
import 'package:api_crud/upload_imagepage.dart';
import 'package:api_crud/view_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:api_crud/view_data.dart';
import 'package:velocity_x/velocity_x.dart'; // Ensure this import is correct based on your file structure

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> insertUser() async {
    if (name.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
      print("Please fill all fields");
      return;
    }

    try {
      String uri = "http://localhost/api_crud/insert_user.php";
      var res = await http.post(Uri.parse(uri), body: {
        "name": name.text,
        "email": email.text,
        "password": password.text
      });

      var response = jsonDecode(res.body);
      if (response['success'] == 'true') {
        print('Data added successfully');
      } else {
        print("Some issue occurred");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp( // Use GetMaterialApp instead of MaterialApp
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("API Flutter CRUD"),
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: name,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the name',
                  hintText: "Michel Owen",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the email',
                  hintText: "example@gmail.com",
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextFormField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter the password',
                  hintText: "*********",
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  insertUser();
                },
                child: Text('Insert'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => ViewData());
                },
                child: Text("View Data"),
              ),
            ),
            Container(
              child:ElevatedButton(onPressed: (){
                Get.to(()=>UploadImage());
              }, child: Text('Upload Image Page'))
            ),
            30.heightBox,
            Container(
              child:ElevatedButton(onPressed: (){
                Get.to(()=>ViewImage());
              }, child: Text('View Image Page'))
            )
          ],
        ),
      ),
    );
  }
}


