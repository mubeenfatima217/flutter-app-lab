import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class accountpage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<accountpage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;
  String? _name;
  String? _email;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    if (_user != null) {
      DocumentSnapshot userDoc = await _firestore.collection('Users').doc(_user!.uid).get();
      setState(() {
        _name = userDoc['FullName'];
        _email = userDoc['Email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Page'),
      ),
      body: Center(
        child: _user == null
            ? Text('No user signed in')
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_name != null && _email != null)
              Column(
                children: [
                  Text('FullName: $_name', style: TextStyle(fontSize: 20)),
                  Text('Email: $_email', style: TextStyle(fontSize: 20)),
                ],
              ),
            if (_name == null || _email == null)
              CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
