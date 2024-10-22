import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../features/authentication/screens/dashboard/farmer_dashboard.dart';
import 'exceptions/signup_email_password_failure.dart';

class FAuthenticationRepository extends GetxController {
  static FAuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser = Rx<User?>(_auth.currentUser);
  var verificationId = ''.obs;


  Future<void> phoneAuthentication(String phoneNo) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNo,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
      },
      codeSent: (verificationId, resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (verificationId) {
        this.verificationId.value = verificationId;
      },
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          Get.snackbar('Error', 'The provided phone number is not valid.');
        } else {
          Get.snackbar('Error', 'Something went wrong. Try Again.');
        }
      },
    );
  }

  Future<bool> verifyOTP(String otp) async {
    var credentials = await _auth.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otp));
    return credentials.user != null;
  }



  Future<String?> createUserWithEmailAndPassword(String email, String password, String fullName, String phone) async {
    try {

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;

      // Create a user record in Firestore with the UID
      await FirebaseFirestore.instance.collection('Farmers').doc(uid).set({
        'Email': email,
        'FullName': fullName,
        'Password': password,
        'Phone': phone,
      });

      firebaseUser.value = userCredential.user;
      Get.offAll(() => const AdminPanel());
      return null;
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userExists = await isEmailRegistered(email);
      if (!userExists) {
        return "Email does not exist. Please check your email or register.";
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else if (e.code == 'too-many-requests') {
        return 'Too many attempts. Please try again later.';
      } else {
        return e.message;
      }
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  Future<bool> isEmailRegistered(String email) async {
    final result = await FirebaseFirestore.instance
        .collection('Farmers')
        .where('Email', isEqualTo: email)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    final snap = await FirebaseFirestore.instance
        .collection('Farmers')
        .where('Email', isEqualTo: email)
        .get();

    if (snap.docs.isEmpty) {
      Get.snackbar("Error", "User isn't registered");
      return false;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Success", "Password Reset email link has been sent");
      return true;
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error In Email Reset", e.message ?? "An error occurred.");
      return false;
    } catch (e) {
      Get.snackbar("Error In Email Reset", "An unexpected error occurred.");
      return false;
    }
  }

  Future<bool> isPhoneRegistered(String phoneNo) async {
    var result = await FirebaseFirestore.instance
        .collection('Farmers')
        .where('Phone', isEqualTo: phoneNo)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

// Future<void> logout() async {
//   await _auth.signOut();
//   Get.offAll(() => const FarmerLoginScreen());
// }
}
