import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewImage extends StatefulWidget {
  const ViewImage({Key? key}) : super(key: key);

  @override
  State<ViewImage> createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  List<dynamic> data = [];
  final String baseUrl = "http://localhost/api_crud/";

  Future<void> viewImage() async {
    String uri = "${baseUrl}view_image.php";
    try {
      var res = await http.get(Uri.parse(uri));
      if (res.statusCode == 200) {
        setState(() {
          data = jsonDecode(res.body);
          print("Data loaded: $data");  // Debug print
        });
      } else {
        print("Error: ${res.statusCode}");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    viewImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Data"),
      ),
      body: data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: data.length,
              itemBuilder: (context, index) {
                String imageUrl = baseUrl + data[index]['imgdata'];
                print("Loading image: $imageUrl");  // Debug print
                return Card(
                  child: Column(
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 100,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          print("Error loading image: $imageUrl, $error");  // Debug print
                          return Icon(Icons.error); // Show error icon if image fails to load
                        },
                      ),
                      SizedBox(height: 8),
                      Text(data[index]['caption']),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
