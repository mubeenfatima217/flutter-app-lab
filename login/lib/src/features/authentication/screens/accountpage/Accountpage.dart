import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/addnewproduct.dart';
import 'package:login/src/features/authentication/screens/Review/ReviewUI.dart';
import 'package:login/src/features/authentication/screens/accountpage/FAQPage.dart';
import 'package:login/src/features/authentication/screens/accountpage/Policies.dart';
import 'package:login/src/features/authentication/screens/dashboard/Farmerorders.dart';
import 'package:login/src/features/authentication/screens/wishlist/wishlist.dart';
import '../AddtoCart/add_to_cart.dart';
import '../homepage/homepage.dart';
import 'CustomerOrder.dart';
import 'AccountInfo.dart'; // Import the AccountInfo class

class AccountPage extends StatelessWidget {
  final List<Map<String, dynamic>> dataList = [
    {"icon": Icons.account_circle, "text": "Account Information"},
    {"icon": Icons.shopping_cart, "text": "My Orders"},
    {"icon": Icons.favorite, "text": "My Wishlist"},
    {"icon": Icons.policy, "text": "Policies"},
    {"icon": Icons.help, "text": "FAQ"},
  ];

  int _selectedIndex = 3;

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AddToCartScreen(),
          ),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Wishlistscreen(),
          ),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AccountPage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String emailNumber =
        user?.email ?? 'No email'; // Default message if phone number is not set

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
                child: Row(
                  children: [
                    Text(
                      'Hello,', // Display user name
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      emailNumber, // Display phone number
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              Divider(
                height: 8,
                thickness: 2,
              ),
            ]),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                if (index.isOdd) {
                  // Odd indices are for dividers
                  return Divider(
                    height: 8,
                    thickness: 2,
                  );
                } else {
                  // Even indices are for list items
                  final dataIndex = (index ~/ 2);
                  return GestureDetector(
                    onTap: () {
                      switch (dataIndex) {
                        case 0:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Accountinfo()));
                          break;
                        case 1:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                          break;
                        case 2:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Wishlistscreen()));
                          break;
                        case 3:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PoliciesPage()));
                          break;
                        case 4:
                          Navigator.push(context, MaterialPageRoute(builder: (context) => FAQsPage()));
                          break;
                        default:
                          break;
                      }
                    },
                    child: ListTile(
                      leading: Icon(dataList[dataIndex]["icon"]),
                      title: Text(dataList[dataIndex]["text"]),
                    ),
                  );
                }
              },
              childCount: dataList.length * 2,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 20), // Add space after the last Divider
            ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  // Navigate to login page or any other page after logout
                  Navigator.pushReplacementNamed(context, '/login'); // Replace '/login' with your desired route
                },
                child: ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout', style: TextStyle(color: Colors.red)),
                ),
              ),
              SizedBox(height: 25,),
            ]),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // Add additional content or widgets here
            ]),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.green,
        selectedItemColor: Color(0xFF013220),
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
        ],
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}
