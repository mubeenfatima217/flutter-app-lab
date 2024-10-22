import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/homecategory/homecategory.dart';
import '../models/product/product.dart';
import '../models/productcategory/productcategory.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference productCollection;
  late CollectionReference categoryCollection;
  late CollectionReference homecategoryCollection; // Fix here
  late CollectionReference orderCollection;
  TextEditingController productNameCtrl = TextEditingController();
  TextEditingController productImageCtrl = TextEditingController();
  TextEditingController productPriceCtrl = TextEditingController();
  TextEditingController productquantityCtrl = TextEditingController();
  String category = 'general';
  bool offer = false;
  String selectedQuantityUnit = 'Kilogram';
  List<Product> products = [];
  List<HomeCategory> homecategory = [];
  List<ProductCategory> productCategory = []; // Adjusted variable name
  List<Product> productsshowinUI =[];
  List<Order> orders = [];

  void filterProductsByName(String query) {
    query = query.toLowerCase().trim();
    List<Product> filteredProducts = products.where((product) {
      String productName = product.name?.toLowerCase().trim() ?? '';
      return productName.contains(query);
    }).toList();
    productsshowinUI.clear();
    productsshowinUI.addAll(filteredProducts);
    update();
  }

  Future<void> onInit() async {
    productCollection = firestore.collection('products');
    categoryCollection = firestore.collection('Category'); // Adjusted collection name
    homecategoryCollection = firestore.collection('homecategory');
    await fetchProducts();
    await fetchCategory();
    await fetchhomecategory();

    super.onInit();

  }

  addProduct() {
    try {
      // Get the current user ID of the logged-in farmer
      String farmerId = FirebaseAuth.instance.currentUser!.uid;
      print('Farmer ID: $farmerId');  // Debugging

      // Create a new document reference for the product
      DocumentReference doc = productCollection.doc();

      // Create a new Product object
      Product product = Product(
        id: doc.id,
        farmerId: farmerId, // Associate the product with the logged-in farmer
        name: productNameCtrl.text,
        category: category,
        price: double.tryParse(productPriceCtrl.text),
        quantity: double.tryParse(productquantityCtrl.text),
        quantityUnit: selectedQuantityUnit,
        image: productImageCtrl.text,
      );

      // Convert the product object to JSON
      final productJson = product.toJson();
      print('Product JSON: $productJson');  // Debugging

      // Set the product data in the Firestore document
      doc.set(productJson);

      // Show success message
      Get.snackbar('Success', 'Product Added Successfully', colorText: Colors.green);

      // Reset input fields to default values
      setValuesDefault();
    } catch (e) {
      // Show error message
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  fetchProducts() async {
    try {
      QuerySnapshot productSnapshot = await productCollection.get();
      final List<Product> retrievedProduct = productSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      products.clear();
      products.assignAll(retrievedProduct);
      productsshowinUI.assignAll(products);
     // Get.snackbar('Success', 'Products fetch Successfully', colorText: Colors.green);
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  fetchCategory() async {
    try {
      QuerySnapshot categorySnapshot = await categoryCollection.get();
      final List<ProductCategory> retrievedCategories = categorySnapshot.docs
          .map((doc) => ProductCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      productCategory.clear();
      productCategory.assignAll(retrievedCategories);

    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }

  fetchhomecategory() async{
    try {
      QuerySnapshot homecategorySnapshot = await homecategoryCollection.get();
      final List<HomeCategory> retrievedHomeCategories = homecategorySnapshot.docs
          .map((doc) => HomeCategory.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      homecategory.clear();
      homecategory.assignAll(retrievedHomeCategories);

    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }

  }
  fetchFruitProducts() async {
    try {
      QuerySnapshot fruitSnapshot = await productCollection.where('category', isEqualTo: 'Fruits').get();
      final List<Product> fruitProducts = fruitSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      // Handle fruit products accordingly
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }
  fetchVegetableProducts() async {
    try {
      QuerySnapshot vegetableSnapshot = await productCollection.where('category', isEqualTo: 'Vegetables').get();
      final List<Product> vegetableProducts = vegetableSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      // Handle vegetable products accordingly
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }
  fetchSeedsProducts() async {
    try {
      QuerySnapshot seedsSnapshot = await productCollection.where('category', isEqualTo: 'Seeds').get();
      final List<Product> seedsProducts = seedsSnapshot.docs
          .map((doc) => Product.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      // Handle seeds products accordingly
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    } finally {
      update();
    }
  }
  deleteproduct(String id) async {
    try {
      await productCollection.doc(id).delete();
      fetchProducts();
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
    }
  }
  editProduct(Product updatedProduct) async {
    try {
      await productCollection.doc(updatedProduct.id).update(updatedProduct.toJson());
      Get.snackbar('Success', 'Product Updated Successfully', colorText: Colors.green);
      fetchProducts(); // Refresh the product list after editing
    } catch (e) {
      Get.snackbar('Error', e.toString(), colorText: Colors.red);
      print(e);
    }
  }

  filerbyCategory(String category)
  {
    productsshowinUI.clear();
    productsshowinUI =products.where((product) => product.category==category).toList();
    update();
  }
  SortByPrice({required bool ascending}){
    List<Product> sortedProducts= List<Product>.from(productsshowinUI);
    sortedProducts.sort((a,b)=>ascending ? a.price!.compareTo(b.price!):b.price!.compareTo(a.price!));
    productsshowinUI=sortedProducts;
    update();
  }


  setValuesDefault() {
    productNameCtrl.clear();
    productImageCtrl.clear();
    productPriceCtrl.clear();
    productquantityCtrl.clear();
    category = 'general';
    offer = false;
    update();
  }
}