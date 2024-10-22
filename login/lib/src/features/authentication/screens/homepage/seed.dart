import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../models/product/product.dart';
import '../product/product_card.dart';
import '../product/product_description.dart';
class SeedsPage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Fetch seed products from Firestore
    Future<List<Product>> fetchSeedProducts() async {
      try {
        QuerySnapshot seedSnapshot = await FirebaseFirestore.instance.collection('products').where('category', isEqualTo: 'Seeds').get();
        List<Product> seedProducts = seedSnapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return Product.fromJson(data)..id = doc.id;
        }).toList();
        return seedProducts;
      } catch (e) {
        print('Error fetching seed products: $e');
        return []; // Return empty list in case of error
      }
    }

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
        title: Text('Seeds', style: TextStyle(
          color: Colors.white, // Change the text color here
        ),),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchSeedProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Product> seedProducts = snapshot.data ?? [];
            if (seedProducts.isEmpty) {
              return Center(child: Text('No seed products available.'));
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of items per row
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8, // Spacing between columns
                    mainAxisSpacing: 8, // Spacing between rows
                  ),
                  itemCount: seedProducts.length,
                  itemBuilder: (context, index) {
                    var product = seedProducts[index];
                    return ProductCard(
                      name: product.name ?? '',
                      imageUrl: product.image ?? '',
                      price: product.price ?? 0.0,
                      quantity: product.quantity ?? 0.0,
                      quantityUnit: product.quantityUnit ?? '',
                      onTap: () {
                        Get.to(() => ProductDescriptionPage(), arguments: {'data': product});
                        // Handle onTap for product card
                      }, productId: product.id ?? '', farmerId: product.farmerId ?? '',
                    );
                  },
                ),
              );
            }
          }
        },
      ),
    );
  }
}
