import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:login/src/features/authentication/screens/dashboard/dashboard.dart';
import 'package:login/src/features/authentication/screens/homepage/homepage.dart';
import 'package:login/src/features/authentication/screens/signup/signup_footer_widget.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../controllers/signup_controller.dart';
import 'form_header_widget.dart';


class SignUp extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signUp(BuildContext context) async {
    final email = emailController.text;
    final password = passwordController.text;
    final fullName = fullNameController.text;

    // Validate email and password
    if (!_isValidEmail(email)) {
      _showErrorDialog(context, 'Invalid email format.');
      return;
    }
    if (!_isValidPassword(password)) {
      _showErrorDialog(context,
          'Password must be at least 8 characters long, and include uppercase, lowercase, and special characters.');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add additional user data to Firestore
      await FirebaseFirestore.instance.collection('customers').doc(
          userCredential.user?.uid).set({
        'userId': userCredential.user?.uid,
        'fullName': fullName,
        'email': email,
        'password': password,
      });

      // Navigate to home page after successful signup
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      print(e.toString());
      _showErrorDialog(context, 'Sign up failed. Please try again.');
    }
  }

  bool _isValidEmail(String email) {
    // Basic email validation
    return RegExp(r'^[^@]+@gmail\.com$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    // Password validation: at least 8 characters, with uppercase, lowercase, and special characters
    return password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[!@#\$&*~]').hasMatch(password);
  }

  void _showErrorDialog(BuildContext context, String message) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerSignUpController());

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          // Add padding on both sides
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                FormHeaderWidget(
                  image: tLoginImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                ),
                const SizedBox(height: 50),
                TextFormField(
                  cursorColor:Colors.green,
                  controller: fullNameController,
                  decoration: InputDecoration(
                    labelText: tFullName,
                    hintText: tFullName,
                    prefixIcon: const Icon(Icons.person_outline_rounded,color: Colors.green,),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelStyle: const TextStyle(color: Colors.green),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Full name is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: tFormHeight - 20),
                TextFormField(
                  cursorColor:Colors.green,
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: tEmail,
                    hintText: tMail,
                    prefixIcon: const Icon(Icons.email_outlined,color: Colors.green,),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelStyle: const TextStyle(color: Colors.green),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    String pattern = r'\w+@\w+\.\w+';
                    if (!RegExp(pattern).hasMatch(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: tFormHeight - 20),
                Obx(() =>
                    TextFormField(
                      cursorColor:Colors.green,
                      controller: passwordController,
                      obscureText: controller.obscureText.value,
                      decoration: InputDecoration(
                        labelText: tPassword,
                        hintText: tPassword,
                        prefixIcon: const Icon(Icons.lock,color: Colors.green,),
                        suffixIcon: IconButton(
                          color: Colors.green,
                          icon: Icon(
                            controller.obscureText.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelStyle: const TextStyle(color: Colors.green),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    )),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                    ),
                    onPressed: () => _signUp(context),
                    child: Text(
                      tSignup.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: tFormHeight - 20),
                CustomerSignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}