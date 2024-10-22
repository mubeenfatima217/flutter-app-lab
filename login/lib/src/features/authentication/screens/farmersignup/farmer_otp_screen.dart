import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/src/features/authentication/screens/dashboard/farmer_dashboard.dart';

class FarmerOtpScreen extends StatelessWidget {
  final String verificationId;
  final otpController = TextEditingController();

  FarmerOtpScreen({required this.verificationId});

  Future<void> verifyOtp(BuildContext context) async {
    final code = otpController.text.trim();
    try {
      final credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        Get.offAll(() => AdminPanel());
      }
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/otp.png', // Path to your image asset
              height: 200, // Adjust height as needed
              width: 240, // Adjust width as needed
            ),
            SizedBox(height: 50),
            TextFormField(
              controller: otpController,
              decoration: InputDecoration(
                labelText: 'Enter OTP',
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: const TextStyle(color: Colors.green),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => verifyOtp(context),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Set the button's background color
              ),
              child: Text(
                'Verify',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
