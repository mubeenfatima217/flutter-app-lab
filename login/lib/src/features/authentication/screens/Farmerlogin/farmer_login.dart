import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:login/src/constants/image_strings.dart';
import 'package:login/src/features/authentication/screens/dashboard/farmer_dashboard.dart';
import 'package:login/src/features/authentication/screens/homepage/homepage.dart';
import 'package:login/src/constants/colors.dart';
import '../../../../constants/text_strings.dart';
import '../../controllers/Farmer_login_controller.dart';
import '../forgetpassword/farmer_forget_password.dart';
import 'Farmer_login_header.dart';
import 'farmer_footer.dart';

class FarmerLoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Navigate to home page after successful login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminPanel()));
    } catch (e) {
      print(e.toString());
      _showErrorDialog(context, 'Login failed. Please check your email and password and try again.');
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
            child: Text('OK',
              style: const TextStyle(
                color: Colors.green,),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FarmerLoginController());
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(9.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 100),
                  FarmerFormHeaderWidget(
                      image: tLoginImage,
                      title: tLoginTitle,
                      subTitle: tLoginSubTitle
                  ),
                  SizedBox(height: 40.0),
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
                  ),
                  SizedBox(height: 10.0),
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
                      ),
                  ),
                  const SizedBox(height: 8),

                  // Forget Password Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: tPrimaryColor,
                      ),
                      onPressed: () => Get.to(() => FarmerForgetPassword()),
                      child: const Text(tForgetPassword),
                    ),
                  ),

                  const SizedBox(height: 10.0),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tPrimaryColor,
                      ),
                      onPressed: () => _signIn(context),
                      child: Text(
                        'Login'.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  FarmerLoginFooterWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildBoxTextField({
    required TextEditingController controller,
    required String labelText,
    bool isPassword = false,
  }) {
    return TextField(
      cursorColor:Colors.green,
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
