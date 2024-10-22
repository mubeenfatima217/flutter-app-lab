import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth package
import 'package:login/src/features/authentication/screens/dashboard/add_product.dart';
import 'package:login/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:login/src/features/authentication/screens/dashboard/Farmerorders.dart';
import '../ScanEvent/Scan_homepage.dart';
import '../homepage/homepage.dart';
import 'farmerprofile.dart'; // Assuming this import is correct

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  String farmerName = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchFarmerName();
  }

  Future<void> _fetchFarmerName() async {
    try {
      // Get the current user's ID
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;

        // Fetch the farmer's data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Farmers').doc(userId).get();

        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          setState(() {
            farmerName = data['FarmerName'] ?? currentUser.email ?? "Ayesha Arshed"; // Use 'FullName' or fallback to email or default
          });
        } else {
          setState(() {
            farmerName = currentUser.email ?? "Ayesha Arshed"; // Fallback to email if no document or 'FullName'
          });
        }
      } else {
        setState(() {
          farmerName = "Ayesha Arshed"; // Fallback if user is not logged in
        });
      }
    } catch (e) {
      setState(() {
        farmerName = "Ayesha Arshed"; // Default fallback in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Farmer Dashboard',
            style: TextStyle(
              color: Colors.white, // Change the text color here
            ),),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 50,left: 10),
              child: Row(
                children: [
                  Text('Hello,', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  SizedBox(width: 10,),
                  Text('$farmerName',style: TextStyle(fontSize: 19,)),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => dashboard()),
                                  );
                                },
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_to_home_screen, size: 50, color: Colors.black.withOpacity(0.6)),
                                      SizedBox(height: 10),
                                      Text('Add Product', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 19),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => OrderManagementScreen()),
                                  );
                                },
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shopping_bag_outlined, size: 50, color: Colors.black.withOpacity(0.6)),
                                      SizedBox(height: 10),
                                      Text('Orders', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ScanHomePage()),
                                  );
                                },
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.document_scanner_outlined, size: 50, color: Colors.black.withOpacity(0.6)),
                                      SizedBox(height: 10),
                                      Text('Scan', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 19),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FarmerAccountpage()),
                                  );
                                },
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.account_circle, size: 50, color: Colors.black.withOpacity(0.6)),
                                      SizedBox(height: 10),
                                      Text('Profile', style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
