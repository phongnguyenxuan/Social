import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myblog/responsive/responsive_layout.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/utils/my_font.dart';
import 'package:myblog/widget/button.dart';

import '../service/auth.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  late bool isVerify = false;
  late Timer timer;
  var userLogin = FirebaseAuth.instance.currentUser!;
  checkEmailVerify() {
    //  await userLogin.reload();
    try {
      setState(() {
        userLogin = FirebaseAuth.instance.currentUser!;
        userLogin.reload();
        isVerify = userLogin.emailVerified;
        if (isVerify == true) {
          timer.cancel();
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ResponsiveLayout()),
              (route) => false);
        }
      });
    } catch (_) {}
  }

  //
  @override
  void initState() {
    super.initState();
    if (!userLogin.emailVerified) {
      userLogin.sendEmailVerification();
    }
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      checkEmailVerify();
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: backgroundColor,
          body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Center(
                  child: Container(
                width: 500,
                height: 600,
                decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(color: Colors.white30),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //head
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Verify your email",
                        style: headerText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          "You will need to verify your email to complete registration",
                          textAlign: TextAlign.center,
                          style: smallText),
                    ),
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: Lottie.asset('assets/lotties/verify.json',
                          animate: true, repeat: true),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                          "An email has been sent to ${userLogin.email} with a link to verify your account. If you have not received the email after a few minutes,please check your spam folder",
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: smallText),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: MyButton(
                        width: 300,
                        height: 50,
                        title: 'Resend email',
                        color: blue,
                        ontap: () {
                          AuthMethods().sendEmailVerification();
                        },
                      ),
                    ),
                    MyButton(
                      width: 300,
                      height: 50,
                      title: 'Skip',
                      color: backgroundColor,
                      border: Border.all(color: Colors.white),
                      ontap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ResponsiveLayout()),
                            (route) => false);
                      },
                    ),
                  ],
                ),
              )))),
    );
  }
}
