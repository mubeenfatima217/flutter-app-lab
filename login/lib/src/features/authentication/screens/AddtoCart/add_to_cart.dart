import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:login/src/features/authentication/screens/Checkout/checkout.dart';
import 'package:login/src/features/authentication/screens/wishlist/wishlist.dart';

import '../../models/product/product.dart';
import '../accountpage/Accountpage.dart';
import '../homepage/homepage.dart';
import 'cartcheckout.dart';

class AddToCartScreen extends StatefulWidget {
  @override
  _AddToCartScreenState createState() => _AddToCartScreenState();
}

class _AddToCartScreenState extends State<AddToCartScreen> {
  double totalPrice = 0;
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
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
        // Already on the wishlist screen, no need to navigate
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
        title: Text('My Cart', style: TextStyle(
          color: Colors.white, // Change the text color here
        ),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('cart').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var cartItems = snapshot.data!.docs;
          totalPrice = 0;
          List<Product> products = [];
          cartItems.forEach((item) {
            totalPrice += item['price'] * item['quantity'];
            products.add(Product(
              id: item.id,
              name: item['name'],
              price: item['price'],
              image: item['imageUrl'],
              quantity: item['quantity'], farmerId: item['farmerId'],
            ));
          });

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    var item = cartItems[index];
                    return ListTile(
                      leading: Image.network(item['imageUrl']),
                      title: Text(item['name']),
                      subtitle: Text('Rs. ${item['price']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove,color: Colors.black,),
                            onPressed: () {
                              if (item['quantity'] > 1) {
                                FirebaseFirestore.instance.collection('cart').doc(item.id).update({
                                  'quantity': item['quantity'] - 1,
                                });
                              }
                            },
                          ),
                          Text('${item['quantity']}'),
                          IconButton(
                            icon: Icon(Icons.add,color: Colors.black,),
                            onPressed: () {
                              FirebaseFirestore.instance.collection('cart').doc(item.id).update({
                                'quantity': item['quantity'] + 1,
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.remove_shopping_cart),
                            onPressed: () {
                              FirebaseFirestore.instance.collection('cart').doc(item.id).delete();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: Rs. $totalPrice',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(
                              totalPrice: totalPrice,
                              products: products,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      child: Text('Checkout', style: TextStyle(
                        color: Colors.white, // Change the text color here
                      ),),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
        onTap: _onItemTapped,
      ),
    );
  }
}
