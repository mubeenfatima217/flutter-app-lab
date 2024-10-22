import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerAccountpage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<FarmerAccountpage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchProfileImageUrl();
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

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Navigate to the login page or any other page after logout.
      // Example:
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
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
          'Farmer Account',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Text("Logout"),
                  value: "logout",
                ),
              ];
            },
            onSelected: (value) {
              if (value == "logout") {
                signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Colors.white, // Change the color of the popup menu icon
            ),
          ),
        ],
      ),
      body: user != null
          ? StreamBuilder<DocumentSnapshot>(
        stream: _firestore.collection('Farmers').doc(user.uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error fetching user data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            // Provide default user data when no user data is found
            return CustomScrollView(
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
                            'Farmer Information',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.black, size: 16),
                              SizedBox(width: 10),
                              Text(
                                'Ayesha Arshed',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.black, size: 16),
                              SizedBox(width: 10),
                              Text(
                                'aieyshu23@gmail.com',
                                style: TextStyle(fontSize: 14, color: Colors.black),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.black, size: 16),
                              SizedBox(width: 10),
                              Text(
                                '+92 3254509180',
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
            );
          }

          var userSnapshot = snapshot.data!;
          String displayName = userSnapshot['FarmerName'] ?? 'Ayesha Arshed';
          String emailNumber = userSnapshot['Email'] ?? 'aieyshu23@gmail.com';
          String phoneNumber = userSnapshot['PhoneNo'] ?? '+92 3254509180';
          return CustomScrollView(
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
                          'Farmer Information',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Icon(Icons.person, color: Colors.black, size: 16),
                            SizedBox(width: 10),
                            Text(
                              displayName,
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.email, color: Colors.black, size: 16),
                            SizedBox(width: 10),
                            Text(
                              emailNumber,
                              style: TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.phone, color: Colors.black, size: 16),
                            SizedBox(width: 10),
                            Text(
                              phoneNumber,
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
          );
        },
      )
          : Center(child: Text('User not signed in')),
    );
  }
}
