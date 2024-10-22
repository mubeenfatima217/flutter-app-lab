// signup_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../controllers/Fsignup_controller.dart';
import 'Farmer_signup_footer.dart';
import 'header.dart';
import 'package:login/src/features/authentication/controllers/Farmer_login_controller.dart';


class FarmerSignUpPage extends StatelessWidget {
  final FSignUpController controller = Get.put(FSignUpController());

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                HeaderWidget(
                  image: tLoginImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  cursorColor:Colors.green,
                  controller: controller.FullName,
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
                  controller: controller.Email,
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
                TextFormField(
                  cursorColor:Colors.green,
                  controller: controller.PhoneNo,
                  decoration: InputDecoration(
                    labelText: tPhoneNo,
                    hintText: tPhone,
                    prefixIcon: const Icon(Icons.phone,color: Colors.green,),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelStyle: const TextStyle(color: Colors.green),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required';
                    }
                    String pattern = r'^\+92 \d{3}\d{7}$';
                    if (!RegExp(pattern).hasMatch(value)) {
                      return 'Enter a valid phone number (+92 xxxxxxxxxx)';
                    }
                    return null;
                  },
                ),


                const SizedBox(height: tFormHeight - 20),
                Obx(() =>
                    TextFormField(
                      cursorColor:Colors.green,
                      controller: controller.Password,
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

                        List<String> errors = [];

                        if (value.length < 8) {
                          errors.add('Password must be at least 8 characters long');
                        }

                        String pattern = r'(?=.*?[A-Z])';
                        if (!RegExp(pattern).hasMatch(value)) {
                          errors.add('Must include both uppercase and lowercase letters');
                        }

                        pattern = r'(?=.*?[0-9])';
                        if (!RegExp(pattern).hasMatch(value)) {
                          errors.add('Password must include at least one number (0-9)');
                        }

                        pattern = r'(?=.*?[!@#\$&~])';
                        if (!RegExp(pattern).hasMatch(value)) {
                          errors.add('Include at least one special character (!@#\$&*~)');
                        }

                        if (errors.isEmpty) {
                          return null;
                        } else {
                          return errors.join('\n');
                        }
                      },
                    )),



                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.registerUser();
                      }
                    },
                    child: Text(
                      tSignup.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: tFormHeight - 20),
                FarmerSignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
