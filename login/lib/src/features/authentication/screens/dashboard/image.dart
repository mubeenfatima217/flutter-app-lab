import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker package
import 'dart:io'; // Import dart:io to use File class
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase storage for uploading images

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  File? _image; // Variable to store the selected image

  // Function to handle image selection from camera or gallery
  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
    );

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // Update the selected image
      });
    }
  }

  // Function to upload image to Firebase storage
  Future<String?> _uploadImage(File image) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('images/${DateTime.now()}.png');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.camera_alt),
              iconSize: 50,
              onPressed: () async {
                await _getImage(ImageSource.camera);
              },
            ),
            SizedBox(width: 20),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  await _getImage(ImageSource.gallery);
                },
                child: Text('Add Image'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
