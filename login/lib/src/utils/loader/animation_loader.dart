import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TColors {
  static const Color dark = Colors.black;
  static const Color light = Colors.white;
// ... Define other colors if needed
}

class TSizes {
  static const double defaultSpace = 20; // You can adjust this as needed
// ... Define other size constants if needed
}

class TAnimationLoaderWidget extends StatelessWidget {
  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const TAnimationLoaderWidget({
    Key? key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation, width: MediaQuery.of(context).size.width * 0.8), // Display Lottie animation
          const SizedBox(height: TSizes.defaultSpace),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black, // Text color
              fontSize: 12, // Minimal size for the text
              // Add other styles like fontWeight if needed
            ),
          ),
          if (showAction) ...[
            const SizedBox(height: TSizes.defaultSpace),
            SizedBox(
              width: 250,
              child: OutlinedButton(
                onPressed: onActionPressed,
                style: OutlinedButton.styleFrom(
                  backgroundColor: TColors.dark, // This may need to be changed based on your theme
                ),
                child: Text(
                  actionText ?? '', // Make sure actionText is not null
                  style: Theme.of(context).textTheme.bodyMedium?.apply(color: TColors.light),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
