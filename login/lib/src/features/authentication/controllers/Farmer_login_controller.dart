import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/dashboard/farmer_dashboard.dart';

import '../../../repository/authentication_repository/fauthentication_repository.dart';

class FarmerLoginController extends GetxController {
  static FarmerLoginController get instance => Get.find();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  RxBool showPassword = true.obs;
  RxBool isLoading = false.obs;

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    isLoading(true); // Start loading
    try {
      String? error = await FAuthenticationRepository.instance
          .loginWithEmailAndPassword(emailController.text.trim(), passwordController.text.trim());

      if (error != null) {
        Get.snackbar(
          'Login Error',
          error,
          snackPosition: SnackPosition.BOTTOM, // Example position
        );
      } else {
        // If no error, navigate to the Dashboard or another appropriate screen
        Get.offAll(() => AdminPanel()); // Replace with your dashboard screen
      }
    } finally {
      isLoading(false); // Stop loading
    }
  }
  var obscureText = true.obs;

  void togglePasswordVisibility() {
    obscureText.toggle();
  }
}