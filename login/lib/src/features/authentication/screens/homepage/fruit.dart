import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../product/product_card.dart';
import '../product/product_description.dart';
import '../../models/product/product.dart';

class Fruitspage extends StatelessWidget {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchFruitProducts() async {
    try {
      QuerySnapshot fruitSnapshot = await firestore
          .collection('products')
          .where('category', isEqualTo: 'Fruits')
          .get();
      List<Product> fruitProducts = fruitSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Product.fromJson(data)..id = doc.id;
      }).toList();
      return fruitProducts;
    } catch (e) {
      print('Error fetching fruit products: $e');
      return [];
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
        title: Text('Fruits', style: TextStyle(
          color: Colors.white, // Change the text color here
        ),),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchFruitProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Product> fruitProducts = snapshot.data ?? [];
            if (fruitProducts.isEmpty) {
              return Center(child: Text('No fruit products available.'));
            } else {
              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: fruitProducts.length,
                  itemBuilder: (context, index) {
                    var product = fruitProducts[index];
                    return ProductCard(
                      name: product.name ?? '',
                      imageUrl: product.image ?? '',
                      price: product.price ?? 0.0,
                      quantity: product.quantity ?? 0.0,
                      quantityUnit: product.quantityUnit ?? '',
                      onTap: () {
                        Get.to(() => ProductDescriptionPage(), arguments: {'data': product});
                      },
                      productId: product.id ?? '', farmerId: product.farmerId ?? '',
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
