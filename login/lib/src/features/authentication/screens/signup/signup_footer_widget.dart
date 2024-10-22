import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../login/login_screen.dart';


class CustomerSignUpFooterWidget extends StatelessWidget {
  const CustomerSignUpFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Text("OR"),
        // const SizedBox(height: tFormHeight - 20),
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //     onPressed: () {},
        //     icon: const Image(
        //       image: AssetImage(tGoogleLogoImage),
        //       width: 20.0,
        //     ),
        //     style: OutlinedButton.styleFrom(
        //       minimumSize: Size(double.infinity, 50), // Increases the height to 50
        //       side: BorderSide(color: Colors.black12), // Border color
        //       foregroundColor: Colors.black87, // Text and icon color
        //     ),
        //     label: Text(tSignInWithGoogle),
        //   ),
        // ),
        TextButton(
          onPressed: () => Get.to(() => CustomerLoginScreen()),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: tAlreadyHaveAnAccount,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const TextSpan(
                  text: tLogin,
                  style: TextStyle(
                    color: tPrimaryColor,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}