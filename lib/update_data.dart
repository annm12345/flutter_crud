import 'package:api_crud/view_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class update_redord extends StatefulWidget {
  String uid;
  String name;
  String email;
  String password;
  update_redord(this.uid, this.name, this.email, this.password, {super.key});

  @override
  State<update_redord> createState() => _update_redordState();
}

class _update_redordState extends State<update_redord> {
  TextEditingController uid=TextEditingController();
  TextEditingController name=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController password=TextEditingController();

  Future <void> updataData () async{
    String uri="http://localhost/api_crud/update_user.php";

    try {
      var update=await http.post(Uri.parse(uri),body: {
        "uid":uid.text,
        "name":name.text,
        "email":email.text,
        "password":password.text,
      }); 
      var response=jsonDecode(update.body);
      if(response['success']=='true'){
        print("upaded data");
        Get.to(()=>ViewData());
      }else{
        print("some issue");
      }

    } catch (e) {
      print(e); 
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    uid.text=widget.uid;
    name.text=widget.name;
    email.text=widget.email;
    password.text=widget.password;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update data"),
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
                  updataData();
                },
                child: Text('update'),
              ),
            ),
            
        ],
      ),
    );
  }
}