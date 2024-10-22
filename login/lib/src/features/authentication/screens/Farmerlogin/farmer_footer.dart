import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:login/src/constants/colors.dart';
import 'package:login/src/features/authentication/screens/homepage/homepage.dart';

import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../farmersignup/farmer_signup.dart';

class FarmerLoginFooterWidget extends StatelessWidget {
  const FarmerLoginFooterWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // const Text("OR"),
        // const SizedBox(height: tFormHeight - 20),
        // SizedBox(
        //   width: double.infinity,
        //   child: OutlinedButton.icon(
        //     icon: const Image(image: AssetImage(tGoogleLogoImage), width: 20.0),
        //     style: OutlinedButton.styleFrom(
        //       minimumSize: Size(double.infinity, 50), // Increases the height to 50
        //       side: BorderSide(color: Colors.black12), // Border color
        //       foregroundColor: Colors.black87, // Text and icon color
        //     ),
        //     onPressed: () {},
        //     label: const Text(tSignInWithGoogle),
        //   ),
        // ),
        // const SizedBox(height: tFormHeight - 20),
        TextButton(

          onPressed: () => Get.to(() => FarmerSignUpPage()),
          child: Text.rich(
            TextSpan(
                text: tDontHaveAnAccount,
                style: Theme.of(context).textTheme.bodyLarge,
                children: const [
                  TextSpan(text: tSignup, style: TextStyle(color: tPrimaryColor))
                ]),
          ),
        ),
      ],
    );
  }
}