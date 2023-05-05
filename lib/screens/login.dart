import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:myblog/screens/register.dart';
import 'package:myblog/service/auth.dart';
import 'package:myblog/utils/global_variable.dart';
import '../utils/my_color.dart';
import '../utils/my_font.dart';
import '../widget/button.dart';
import '../widget/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  //
  //
  @override
  void dispose() {
    super.dispose();
  }

  void signUserIn() async {
    try {
      //
      showDialog(
          context: context,
          builder: (context) =>
              Center(child: Lottie.asset('assets/lotties/loading.json')));
      await AuthMethods().loginWithEmail(
        email: emailController.text,
        password: passwordController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (_) {
      // ignore: avoid_print
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Center(
              child: Container(
                width: size.width > webScreenSize ? 600 : size.width,
                height: size.height,
                constraints: BoxConstraints(maxHeight: size.height),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //form login
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: RichText(
                            text: TextSpan(
                                text: 'Welcome back!\n',
                                style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 25),
                                children: [
                                  TextSpan(
                                    text: 'Please sign in to your account',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white54,
                                        fontSize: 15),
                                  )
                                ]),
                          ),
                        ),
                        //email textfield
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: MyTextField(
                                  height: 50,
                                  width: 300,
                                  text: "Email",
                                  icon: const Icon(
                                    FontAwesomeIcons.envelope,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  controller: emailController,
                                  radius: 15,
                                  isPass: false,
                                ),
                              ),
                              //password textfield
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: MyTextField(
                                  height: 50,
                                  width: 300,
                                  text: "Password",
                                  icon: const Icon(
                                    FontAwesomeIcons.key,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  controller: passwordController,
                                  radius: 15,
                                  isPass: true,
                                ),
                              ),
                              //forget password
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot password',
                                      style: GoogleFonts.nunitoSans(
                                          color: Colors.white,
                                          fontSize: 15,
                                          decorationColor: Colors.white,
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )),
                              // button sign in
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                    child: MyButton(
                                  color: blue,
                                  title: 'Sign in',
                                  ontap: () {
                                    signUserIn();
                                  },
                                  width: 300,
                                  height: 70,
                                )),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Text(
                            'Or sign in with',
                            style: bodyText,
                          ),
                        ),
                        //google button
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: MyButton(
                                ontap: () {},
                                height: 70,
                                width: 300,
                                color: Colors.white,
                                title: 'Sign in with Google',
                                icon: Image.asset('assets/images/icon-gg.png')),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: GoogleFonts.nunitoSans(
                                  decorationColor: Colors.white,
                                  color: Colors.white,
                                  fontSize: 15),
                            ),
                            //register
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterScreen()));
                                },
                                child: Text(
                                  " Sign Up for free",
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.blueAccent,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
