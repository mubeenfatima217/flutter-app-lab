import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common_widgets/drop_down_button.dart';
import '../product/product_card.dart';
import '../product/product_description.dart';
import '../../controllers/dashboard_controller.dart';

class allproduct extends StatefulWidget {
  const allproduct({Key? key}) : super(key: key);

  @override
  _AllProductState createState() => _AllProductState();
}

class _AllProductState extends State<allproduct> {
  late String imageUrl;
  final Storage = FirebaseStorage.instance;
  TextEditingController editingController = TextEditingController();
  bool isSearching = false;

  void filterSearchResults(String query, HomeController ctrl) {
    if (query.isNotEmpty) {
      ctrl.filterProductsByName(query);
    } else {
      ctrl.fetchProducts(); // Reset to original list when query is empty
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
              leading: IconButton(
                icon: Icon(Icons.arrow_back,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: isSearching
                  ? TextField(
                cursorColor:Colors.white,
                onChanged: (value) {
                  filterSearchResults(value, ctrl);
                },
                controller: editingController,
                decoration: InputDecoration(
                  labelText: "Search",
                  labelStyle: TextStyle(color: Colors.white), // Label text color
                  hintText: "Search item",
                  hintStyle: TextStyle(color: Colors.white), // Hint text color set to white
                  prefixIcon: Icon(Icons.search,color: Colors.white,),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10), // Adjust vertical padding to reduce height
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green), // Set the border color to green when focused
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Text(
                      'Farmfusion Exchange',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                    },
                    icon: Icon(Icons.search, color: Colors.white),
                  )
                ],
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10), // Adjust the space between the AppBar and other widgets
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: ctrl.productCategory.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            ctrl.filerbyCategory(
                                ctrl.productCategory[index].name ?? '');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Chip(
                              label: Text(
                                ctrl.productCategory[index].name ?? 'Error',
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10), // Adjust the space between category chips and other widgets
                Padding(
                  padding: const EdgeInsets.only(left: 200.0, top: 10),
                  child: Row(
                    children: [
                      Dropdownbtn(
                        items: ['Rs. Low to High', 'Rs. High to Low'],
                        selectedItemText: 'Sort',
                        onSelected: (selected) {
                          ctrl.SortByPrice(
                            ascending: selected == 'Rs. Low to High'
                                ? true
                                : false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: ctrl.productsshowinUI.length,
                    itemBuilder: (context, index) {
                      return ProductCard(
                        name: ctrl.productsshowinUI[index].name ?? 'No Name',
                        imageUrl:
                        ctrl.productsshowinUI[index].image ?? 'Url',
                        price: ctrl.productsshowinUI[index].price ?? 00,
                        quantity:
                        ctrl.productsshowinUI[index].quantity ?? 00,
                        quantityUnit: ctrl.productsshowinUI[index].quantityUnit ??
                            'Unit',
                        onTap: () {
                          Get.to(ProductDescriptionPage(),
                              arguments: {'data': ctrl.productsshowinUI[index]});
                        }, productId: ctrl.productsshowinUI[index].id ?? '',
                        farmerId: ctrl.productsshowinUI[index].farmerId ?? '', // Pass the farmerId here

                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
