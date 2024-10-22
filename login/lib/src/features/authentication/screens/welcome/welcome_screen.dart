import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/image_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../farmersignup/farmer_signup.dart';
import '../signup/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var brightness = mediaQuery.platformBrightness;
    final isDarkMode = brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? tSecondaryColor : tOnBoardingPage1Color,
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize,),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min, // Make the column take up less space
          children: [
            const SizedBox(height: tDefaultSpace*3),

            // Row to hold both images
            const Row(
              children: [
                Expanded(
                  child: Image(
                    image: AssetImage(tWelcomeScreenImage),
                    width: 350, // Specify your desired width
                    height: 350, // Specify your desired height
                    fit: BoxFit.fitWidth,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 70),


            Column(
              children: [
                Text(tWelcomeTitle, style: Theme.of(context).textTheme.displayLarge),
                Text(tWelcomeSubTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center),
              ],
            ),
            const SizedBox(height: 50),
// More space at the bottom to push content ups
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.to(() => FarmerSignUpPage()),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: tPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: tButtonHeight)
                    ),
                    child: Text(tFarmer.toUpperCase()),
                  ),
                ),

                const SizedBox(width: tDefaultSpace),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => SignUp()),
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        foregroundColor: tWhiteColor,
                        backgroundColor: tPrimaryColor,
                        padding: const EdgeInsets.symmetric(vertical: tButtonHeight)
                    ),
                    child: Text(tCustomer.toUpperCase()),

                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
