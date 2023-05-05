import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:myblog/screens/verify.dart';
import 'package:myblog/service/auth.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/utils.dart';
import '../utils/my_color.dart';
import '../utils/my_font.dart';
import '../widget/button.dart';
import '../widget/textfield.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  //
  @override
  void initState() {
    super.initState();
    if (_file.isEmpty) {}
  }

  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
  }

  Uint8List _file = Uint8List(0);
  //pick image
  _pickImage() async {
    Uint8List file = await pickImage(ImageSource.gallery, context, false);
    if (file.isNotEmpty) {
      setState(() {
        _file = file;
      });
    } else {
      ByteData byteData = await rootBundle.load('assets/images/astronaut.png');
      setState(() {
        _file = byteData.buffer.asUint8List();
      });
    }
  }

  //upload data

  //
  void _registerUser() async {
    try {
      //loading
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: Lottie.asset('assets/lotties/loading.json'));
          });
      await AuthMethods().signUpWithEmail(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
          confirm: confirmPassController.text,
          file: _file);
    } on FirebaseAuthException catch (_) {}
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: RichText(
                          text: TextSpan(
                              text: 'Create new account\n',
                              style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                              children: [
                                TextSpan(
                                  text: 'Please fill in the form to continue',
                                  style: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white54,
                                      fontSize: 13),
                                )
                              ]),
                        ),
                      ),
                      //form register
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0, left: 20),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SizedBox(
                                width: 70,
                                height: 70,
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 150,
                                        child: _file.isNotEmpty
                                            ? ClipOval(
                                                child: AspectRatio(
                                                    aspectRatio: 1 / 1,
                                                    child: Image.memory(_file)))
                                            : ClipOval(
                                                child: Image.asset(
                                                    'assets/images/astronaut.png',
                                                    fit: BoxFit.cover),
                                              ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          _pickImage();
                                        },
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 74, 74, 74),
                                              borderRadius:
                                                  BorderRadius.circular(180),
                                              border: Border.all(
                                                  color: Colors.white)),
                                          child: const Icon(
                                            FontAwesomeIcons.camera,
                                            color: Color.fromARGB(
                                                255, 255, 252, 252),
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
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
                                    text: "Username",
                                    maxLength: 15,
                                    icon: const Icon(
                                      FontAwesomeIcons.userAstronaut,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    controller: usernameController,
                                    radius: 15,
                                    isPass: false,
                                  ),
                                ),
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
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: MyTextField(
                                    height: 50,
                                    width: 300,
                                    text: "Confirm password",
                                    controller: confirmPassController,
                                    icon: const Icon(
                                      FontAwesomeIcons.key,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    radius: 15,
                                    isPass: true,
                                  ),
                                ),
                                // button sign in
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Center(
                                      child: MyButton(
                                    width: 300,
                                    height: 70,
                                    title: 'Sign Up',
                                    color: blue,
                                    ontap: () {
                                      _registerUser();
                                    },
                                  )),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "If you have an account ,",
                                style: bodyText,
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
                                                const LoginScreen()));
                                  },
                                  child: Text(
                                    "Sign in",
                                    style: linkText,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
