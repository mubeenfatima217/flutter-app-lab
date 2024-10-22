
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/authentication/models/farmer_model.dart';


class FarmerRepository extends GetxController {
  static FarmerRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUser(FarmerModel farmer) async {
    await _db.collection("Farmers").add(farmer.toJson())
        .whenComplete(
          () => Get.snackbar("Success", "Your account has been created.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green),
    )
        .catchError((error, stackTrace){
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.1),
          colorText: Colors.red);
      print(error.toString());
    });
  }

}