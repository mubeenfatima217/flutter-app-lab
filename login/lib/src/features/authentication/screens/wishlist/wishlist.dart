import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/controllers/dashboard_controller.dart';
import 'package:login/src/features/authentication/models/product/product.dart';
import '../AddtoCart/add_to_cart.dart';
import '../accountpage/Accountpage.dart';
import '../homepage/homepage.dart';
import '../product/product_card.dart';
import '../product/product_description.dart';

class Wishlistscreen extends StatefulWidget {
  const Wishlistscreen({Key? key}) : super(key: key);

  @override
  _WishlistscreenState createState() => _WishlistscreenState();
}

class _WishlistscreenState extends State<Wishlistscreen> {
  int _selectedIndex = 2;

  Future<List<Map<String, dynamic>>> fetchWishlistItems() async {
    var wishlistCollection = FirebaseFirestore.instance.collection('wishlist');
    var snapshot = await wishlistCollection.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

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
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        return RefreshIndicator(
          onRefresh: () async {
            ctrl.fetchProducts();
          },
          child: Scaffold(
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
              title: Text('Wishlist', style: TextStyle(
                color: Colors.white, // Change the text color here
              ),),
            ),
            body: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchWishlistItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No items in wishlist'));
                }
                var items = snapshot.data!;
                return GridView.builder(
                  padding: EdgeInsets.only(bottom: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items per row
                    crossAxisSpacing: 8, // Space between columns
                    mainAxisSpacing: 8, // Space between rows
                    childAspectRatio: 0.8, // Aspect ratio for each item
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var item = items[index];
                    var product = Product.fromJson(items[index]);
                    return ProductCard(
                      name: item['name'],
                      imageUrl: item['imageUrl'],
                      price: item['price'],
                      quantity: item['quantity'],
                      quantityUnit: item['quantityUnit'],
                      productId: item['productId'],
                      onTap: () {
                        Get.to(ProductDescriptionPage(), arguments: {'data': ctrl.productsshowinUI[index]});
                      }, farmerId: product.farmerId ?? '',
        // Pass the productId here
                    );
                  },
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
          ),
        );
      },
    );
  }
}
