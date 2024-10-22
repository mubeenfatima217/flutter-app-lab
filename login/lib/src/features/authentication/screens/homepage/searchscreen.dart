import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/dashboard_controller.dart';
import '../../models/product/product.dart';
import '../product/product_card.dart';
import '../product/product_description.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        List<Product> filteredProducts = ctrl.products.where((product) =>
            product.name!.toLowerCase().contains(searchController.text.toLowerCase())).toList();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: TextField(
              cursorColor:Colors.green,
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Products...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white54),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {}); // Trigger rebuild when the search text changes
              },
            ),
          ),
          body: filteredProducts.isNotEmpty
              ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              return ProductCard(
                name: filteredProducts[index].name ?? 'No Name',
                imageUrl: filteredProducts[index].image ?? 'Url',
                price: filteredProducts[index].price ?? 0.0,
                quantity: filteredProducts[index].quantity ?? 0.0,
                quantityUnit: filteredProducts[index].quantityUnit ?? 'Unit',
                onTap: () {
                  Get.to(ProductDescriptionPage(), arguments: {'data': filteredProducts[index]});
                }, productId: '', farmerId: 'FpgVuN166hbzTCynImIZPgwLzQx2',
              );
            },
          )
              : Center(
            child: Text('No products found.'),
          ),
        );
      },
    );
  }
}
