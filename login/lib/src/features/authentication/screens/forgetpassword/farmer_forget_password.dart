import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';

class FarmerForgetPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  void _sendPasswordResetEmail(BuildContext context) async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showErrorDialog(context, 'Email is required');
      return;
    }

    try {
      // Set password reset flag in Firestore
      await FirebaseFirestore.instance.collection('Farmers')
          .where('Email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) async {
          await doc.reference.update({'passwordResetRequested': true});
        });
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccessDialog(context, 'Password reset email sent. Check your inbox.');
      // Update password in Firebase collection
    } catch (e) {
      print(e.toString());
      _showErrorDialog(context, 'Failed to send password reset email. Please try again.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              tForgetPasswordImage,
              height: 150, // Adjust the height as needed
            ),

            Text(
              'Enter your email address to receive a password reset link',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                labelStyle: TextStyle(color: Colors.green),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                ),
                onPressed: () => _sendPasswordResetEmail(context),
                child: Text(
                  'Send Reset Link',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
