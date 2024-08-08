import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data'; 
import 'package:http/http.dart' as http;


class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  TextEditingController caption = TextEditingController();
  String? imagename;
  String? imagedata;
  File? imagePath;
  Uint8List? webImage;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> getImage() async {
    try {
      final XFile? pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        if (kIsWeb) {
          final imageBytes = await pickedFile.readAsBytes();
          setState(() {
            webImage = imageBytes;
            imagename = pickedFile.name; // Set image name for web
            imagedata = base64Encode(imageBytes); // Set image data for web
          });
        } else {
          setState(() {
            imagePath = File(pickedFile.path);
            imagename = pickedFile.path.split('/').last;
            imagedata = base64Encode(imagePath!.readAsBytesSync());
          });
        }
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadImage() async {
    try {
      String uri = "http://localhost/api_crud/upload_image.php";
      var res = await http.post(
        Uri.parse(uri),
        body: {
          "caption": caption.text,
          "name": imagename ?? '',
          "data": imagedata ?? '',
        },
      );
      var response = jsonDecode(res.body);
      if (response['success'] == 'true') {
        print('Data added successfully');
      } else {
        print("Some issue occurred");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            10.heightBox,
            TextFormField(
              controller: caption,
              decoration: const InputDecoration(
                focusColor: Colors.grey,
                isDense: true,
                filled: true,
                border: InputBorder.none,
                hintText: 'Image caption',
                labelText: "Enter the image Caption",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ).box.width(context.screenWidth - 20).makeCentered(),
            20.heightBox,
            kIsWeb
                ? (webImage != null
                    ? Image.memory(webImage!)
                    : const Text('Image Not chosen Yet!'))
                : (imagePath != null
                    ? Image.file(imagePath!)
                    : const Text('Image Not chosen Yet!')),
            20.heightBox,
            ElevatedButton(
              onPressed: getImage,
              child: const Text("Choose Image"),
            ).box.roundedSM.shadowSm.color(const Color.fromARGB(255, 212, 243, 33)).make(),
            10.heightBox,
            ElevatedButton(
              onPressed: () {
                // Add your upload image logic here
                uploadImage();
              },
              child: const Text('Upload Image'),
            ).box.roundedSM.shadowSm.color(Colors.blue).make(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: UploadImage(),
  ));
}
