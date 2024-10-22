import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/repository/user_repository/farmer_repository.dart';
import '../../../repository/authentication_repository/fauthentication_repository.dart';
import '../models/farmer_model.dart';

class CustomerLoginController extends GetxController {
  static CustomerLoginController get instance => Get.find();

  var obscureText = true.obs;

  void togglePasswordVisibility() {
    obscureText.toggle();
  }
}
