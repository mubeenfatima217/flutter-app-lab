// signup_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/farmersignup/farmer_otp_screen.dart';

class FSignUpController extends GetxController {
  final FullName = TextEditingController();
  final Email = TextEditingController();
  final Password = TextEditingController();
  final PhoneNo = TextEditingController();

  final obscureText = true.obs;

  void togglePasswordVisibility() {
    obscureText.toggle();
  }

  Future<void> registerUser() async {
    try {
      // Register user with email and password using Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: Email.text.trim(),
        password: Password.text.trim(),
      );

      // Store additional user data in Firestore
      await FirebaseFirestore.instance.collection('Farmers').doc(userCredential.user!.uid).set({
        'farmerId': userCredential.user?.uid,
        'FarmerName': FullName.text.trim(),
        'Email': Email.text.trim(),
        'PhoneNo': PhoneNo.text.trim(),
        'password':Password.text.trim(),
      });


      // Send OTP to phone number
      await sendOtpToPhoneNumber(PhoneNo.text.trim());

    } catch (e) {
      // Handle registration errors
      print(e.toString());
    }
  }



  Future<void> sendOtpToPhoneNumber(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        Get.snackbar('Error', e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        Get.to(() => FarmerOtpScreen(verificationId: verificationId));
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
