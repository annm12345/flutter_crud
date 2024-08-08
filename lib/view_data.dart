import 'dart:convert';
import 'package:api_crud/update_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ViewData extends StatefulWidget {
  const ViewData({super.key});

  @override
  State<ViewData> createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  List userdata = [];
  bool isLoading = true;

  Future <void> deletedata(String id) async{
    String uri = "http://localhost/api_crud/delete_user.php";
    try {
      var delete= await  http.post(Uri.parse(uri),body: {
        "id":id,
      });

      var response=jsonDecode(delete.body);
      if(response['success']=="true"){
        print('data deleted');
        getdata();
      }else{
        print('some issue');
      }

    } catch (e) {
      print(e); 
    }

    
  }

  Future<void> getdata() async {
    String uri = "http://localhost/api_crud/view_user.php";
    try {
      var response = await http.get(Uri.parse(uri));
      if (response.statusCode == 200) {
        setState(() {
          userdata = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        print("Failed to load data");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Data"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: userdata.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                      Get.to(()=>update_redord(userdata[index]['uid'],userdata[index]['name'],userdata[index]['email'],userdata[index]['password'],));
                    },
                    leading: Icon(CupertinoIcons.profile_circled,color: Colors.blue,),
                    title: Text(userdata[index]["name"]),
                    subtitle: Text(userdata[index]["email"]),
                    trailing: IconButton(icon:const Icon(Icons.delete,color: Colors.red,),onPressed:(){
                      deletedata(userdata[index]['uid']);
                    }),
                  ),
                );
              },
            ),
    );
  }
}
