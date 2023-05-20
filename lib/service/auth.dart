import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myblog/models/user.dart' as model;
import 'package:myblog/service/storage_methods.dart';
import 'package:myblog/widget/snackbar.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot.data() as Map<String, dynamic>);
  }

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String confirm,
    required String username,
    required Uint8List file,
  }) async {
    try {
      if (username.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          confirm.isNotEmpty &&
          password == confirm) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics/${cred.user!.uid}/', file);

        model.User _user = model.User(
          displayName: username,
          nickname: "",
          bio: "",
          uid: cred.user!.uid,
          photoURL: photoUrl,
          email: email,
          followers: [],
          following: [],
          likesPosts: [],
        );

        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(_user.toJson());
        // await sendEmailVerification();
      } else if (password != confirm) {
        Get.snackbar('', '',
            backgroundColor: Colors.transparent,
            forwardAnimationCurve: Curves.decelerate,
            duration: const Duration(milliseconds: 2500),
            barBlur: 0,
            overlayBlur: 0,
            maxWidth: 600,
            titleText: cSnackBar(
              title: 'Account creation failed',
              message: 'Password not match',
              isErrorBanner: true,
            ));
      } else {
        Get.snackbar('', '',
            backgroundColor: Colors.transparent,
            forwardAnimationCurve: Curves.decelerate,
            duration: const Duration(milliseconds: 2500),
            barBlur: 0,
            overlayBlur: 0,
            maxWidth: 600,
            titleText: cSnackBar(
              title: 'Account creation failed',
              message: 'Please enter all the fields',
              isErrorBanner: true,
            ));
      }
    } on FirebaseAuthException catch (e) {
      print(e.message!);
      Get.snackbar('', '',
          backgroundColor: Colors.transparent,
          forwardAnimationCurve: Curves.decelerate,
          duration: const Duration(milliseconds: 2500),
          barBlur: 0,
          overlayBlur: 0,
          maxWidth: 600,
          titleText: cSnackBar(
            title: 'Account creation failed',
            message: e.message!,
            isErrorBanner: true,
          ));
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    //  required BuildContext context,
  }) async {
    try {
      //loading
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        Get.snackbar('', '',
            backgroundColor: Colors.transparent,
            forwardAnimationCurve: Curves.decelerate,
            duration: const Duration(milliseconds: 2500),
            barBlur: 0,
            overlayBlur: 0,
            maxWidth: 600,
            titleText: cSnackBar(
              title: 'Login Success',
              message: 'Welcome back my friend',
              isErrorBanner: false,
            ));
      } else {
        Get.snackbar('', '',
            backgroundColor: Colors.transparent,
            forwardAnimationCurve: Curves.decelerate,
            duration: const Duration(milliseconds: 2500),
            barBlur: 0,
            overlayBlur: 0,
            maxWidth: 600,
            titleText: cSnackBar(
              title: 'Error Login',
              message: 'Please enter all the fields',
              isErrorBanner: true,
            ));
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('', '',
          backgroundColor: Colors.transparent,
          forwardAnimationCurve: Curves.decelerate,
          duration: const Duration(milliseconds: 2500),
          barBlur: 0,
          overlayBlur: 0,
          maxWidth: 600,
          titleText: cSnackBar(
            title: 'Error Login',
            message: e.message!,
            isErrorBanner: true,
          ));
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      if ((_auth.currentUser!.emailVerified == false)) {
        _auth.currentUser!.sendEmailVerification();
      }
      print('Email verification sent!');
      //showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      // showSnackBar(context, e.message!); // Display error message
    }
  }

  // GOOGLE SIGN IN
  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     if (kIsWeb) {
  //       GoogleAuthProvider googleProvider = GoogleAuthProvider();

  //       googleProvider
  //           .addScope('https://www.googleapis.com/auth/contacts.readonly');

  //       await _auth.signInWithPopup(googleProvider);
  //     } else {
  //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //       final GoogleSignInAuthentication? googleAuth =
  //           await googleUser?.authentication;

  //       if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
  //         // Create a new credential
  //         final credential = GoogleAuthProvider.credential(
  //           accessToken: googleAuth?.accessToken,
  //           idToken: googleAuth?.idToken,
  //         );
  //         UserCredential userCredential =
  //             await _auth.signInWithCredential(credential);

  //         // if you want to do specific task like storing information in firestore
  //         // only for new users using google sign in (since there are no two options
  //         // for google sign in and google sign up, only one as of now),
  //         // do the following:

  //         // if (userCredential.user != null) {
  //         //   if (userCredential.additionalUserInfo!.isNewUser) {}
  //         // }
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     showSnackBar(context, e.message!); // Displaying the error message
  //   }
  // }

  // SIGN OUT
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      //showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      //  showSnackBar(context, e.message!); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }
}
