import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TFColors {
  static const Color dark = Colors.black;
  static const Color white = Colors.white;
}

class THelperFunctions {
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}

class TAnimationLoaderWidget extends StatelessWidget {
  final String text;
  final String animation;

  const TAnimationLoaderWidget({Key? key, required this.text, required this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You might have your own implementation of animation loader
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation, width: MediaQuery.of(context).size.width*0.8),
          const SizedBox(height: 20),
          Text(text),
        ],
      ),
    );
  }
}

class TFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  /// - text: The text to be displayed in the loading dialog.
  /// - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible: false, // The dialog can't be dismissed by tapping outside it
      builder: (_) => WillPopScope(
        onWillPop: () async => false, // Disable popping with the back button
        child: Container(
          color: THelperFunctions.isDarkMode(Get.context!) ? TFColors.dark : TFColors.white,
          width: double.infinity,
          height: double.infinity,
          child: TAnimationLoaderWidget(text: text, animation: animation),
        ),
      ),
    );
  }

  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }

}
