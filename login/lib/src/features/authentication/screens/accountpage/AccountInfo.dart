import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Accountinfo extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<Accountinfo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String displayName = 'FullName';
  String emailNumber = 'Email';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchProfileImageUrl();
  }

  Future<void> fetchUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userSnapshot = await _firestore.collection('customers').doc(user.uid).get();
        if (userSnapshot.exists) {
          setState(() {
            displayName = userSnapshot['fullName'] ?? 'User';
            emailNumber = userSnapshot['email'] ?? 'No email';
          });
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('Current user is null');
    }
  }


  Future<void> fetchProfileImageUrl() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String uid = user.uid;
      String imagePath = 'profile_images/$uid.png'; // Update the image path based on your storage structure
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child(imagePath);
      try {
        String profileImage = await ref.getDownloadURL();
        setState(() {
          profileImageUrl = profileImage;
        });
      } catch (e) {
        print('Profile image not found: $e');
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      String uid = FirebaseAuth.instance.currentUser?.uid ?? 'default';
      String imagePath = 'profile_images/$uid.png';
      Reference ref = storage.ref().child(imagePath);
      TaskSnapshot uploadTask = await ref.putFile(File(image.path));
      String imageUrl = await uploadTask.ref.getDownloadURL();
      setState(() {
        profileImageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 19),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: pickImage,
                        child: Column(
                          children: [
                            SizedBox(height: 40),
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.grey,
                              backgroundImage: profileImageUrl.isNotEmpty
                                  ? NetworkImage(profileImageUrl)
                                  : null,
                              child: profileImageUrl.isEmpty
                                  ? Icon(
                                Icons.camera_alt,
                                size: 30,
                              )
                                  : null,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Add Profile Image',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 50),
                            Divider(
                              height: 8,
                              thickness: 2,
                              indent: 0,
                              endIndent: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'User Information',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.black, size: 16,),
                        SizedBox(width: 10),
                        Text(
                          displayName,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.black, size: 16,),
                        SizedBox(width: 10),
                        Text(
                          emailNumber,
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              SizedBox(height: 0),
              Divider(
                height: 8,
                thickness: 2,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
