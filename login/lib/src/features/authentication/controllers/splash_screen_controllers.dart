import 'package:get/get.dart';
import 'package:login/src/features/authentication/screens/welcome/welcome_screen.dart';
import '../screens/on_boarding/on_boarding_screen.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  @override
  void onInit() {
    super.onInit();
    startAnimation();
  }

  Future startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    animate.value = true;
    await Future.delayed(const Duration(milliseconds: 5000));
    navigateToOnBoardingScreen();
  }

  void navigateToOnBoardingScreen() {
    // Navigating to the boarding screen instead of the welcome screen
    Get.off(() => const OnBoardingScreen()); // Use the actual onboarding screen widget name
  }
}