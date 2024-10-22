import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/dashboard/add_product.dart';
import 'package:login/src/features/authentication/controllers/dashboard_controller.dart';

import '../../models/product/product.dart';

class dashboard extends StatelessWidget {
  const dashboard({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (ctrl) {
        // Filter products based on the logged-in farmer's ID
        List<Product> userProducts = ctrl.products
            .where((product) => product.farmerId == FirebaseAuth.instance.currentUser!.uid)
            .toList();

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
            title: Text('Product List',
              style: TextStyle(
                color: Colors.white,
              ),),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 19.0),
            child: ListView.separated(
              itemCount: userProducts.length,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(userProducts[index].name ?? '', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  subtitle: Text(userProducts[index].price.toString()),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ctrl.deleteproduct(ctrl.products[index].id ?? '');
                    },
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.to(Addproductpage());
            },
            backgroundColor: Colors.green,
            child: Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}
