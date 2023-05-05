import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myblog/screens/profile/profile.dart';
import 'package:myblog/service/storage_methods.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/utils/utils.dart';
import 'package:myblog/widget/button.dart';
import 'package:myblog/widget/textfield.dart';
import 'package:myblog/models/user.dart' as model;

class EditProfile extends StatefulWidget {
  final String uid;
  final String username;
  final String nickname;
  final String bio;
  final String photoURL;
  final String coverPhoto;
  const EditProfile(
      {super.key,
      required this.uid,
      required this.username,
      required this.nickname,
      required this.photoURL,
      required this.bio,
      required this.coverPhoto});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  //
  var userData = {};
  model.User user = model.User();
  //
  @override
  void initState() {
    super.initState();
    usernameController.text = widget.username;
    nicknameController.text = widget.nickname;
    bioController.text = widget.bio;
    photoURL = widget.photoURL;
    getData();
  }

  getData() async {
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      user = model.User.fromSnap(userSnap.data()!);
      setState(() {});
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  //image pick
  Uint8List? _file;
  String photoURL = '';

  Uint8List? _coverFile;
  String coverPhoto = '';
  //pick image
  _pickImage() async {
    try {
      Uint8List file = await pickImage(ImageSource.gallery, context, false);
      setState(() {
        _file = file;
      });
    } on PlatformException catch (_) {
      // print(e);
    }
  }

  //
  _pickCoverImage() async {
    try {
      Uint8List file = await pickImage(ImageSource.gallery, context, true);
      setState(() {
        _coverFile = file;
      });
    } on PlatformException catch (_) {
      // print(e);
    }
  }

  //update profile
  Future<void> updateProfile(
      String username, String nickname, String bio) async {
    if (_file != null) {
      photoURL = await StorageMethods()
          .uploadImageToStorage('profilePics/${widget.uid}/', _file!);
    } else {
      photoURL = widget.photoURL;
    }
    if (_coverFile != null) {
      coverPhoto = await StorageMethods().uploadImageToStorage(
          'profilePics/${widget.uid}/cover/', _coverFile!);
    } else {
      coverPhoto = widget.coverPhoto;
    }
    try {
      //loading
      // ignore: use_build_context_synchronously
      //? update users doc
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({
        'displayName': username,
        'nickname': nickname,
        'photoURL': photoURL,
        'bio': bio,
        'coverPhoto': coverPhoto,
      });
      await userController.refreshUser();
      //? update posts doc
      await FirebaseFirestore.instance
          .collection('Posts')
          .where('uid', isEqualTo: widget.uid)
          .get()
          .then((value) {
        for (var element in value.docs) {
          FirebaseFirestore.instance
              .collection('Posts')
              .doc(element.id)
              .update({'user': userController.getUser.toJson()});
        }
      });
      //  ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  )),
          (route) => false);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    try {
      return SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: size.height),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: <Widget>[
                      // background image and bottom contents
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 200.0,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(
                                  child: _coverFile != null
                                      ? Image.memory(_coverFile!)
                                      : user.coverPhoto != ''
                                          ? Image.network(user.coverPhoto!,
                                              fit: BoxFit.cover)
                                          : Container(
                                              color: blue,
                                              child: const Center(
                                                child: Text(
                                                    'Upload your cover photo'),
                                              ),
                                            ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: InkWell(
                                    onTap: () {
                                      _pickCoverImage();
                                    },
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 74, 74, 74),
                                          borderRadius:
                                              BorderRadius.circular(180),
                                          border:
                                              Border.all(color: Colors.white)),
                                      child: const Icon(
                                        FontAwesomeIcons.camera,
                                        color:
                                            Color.fromARGB(255, 255, 252, 252),
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 70),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MyTextField(
                                      width: 200,
                                      height: 50,
                                      text: "Username",
                                      isEmpty: false,
                                      maxLength: 15,
                                      radius: 15,
                                      controller: usernameController,
                                      initValue: widget.username,
                                      isPass: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MyTextField(
                                      width: 200,
                                      height: 50,
                                      text: "Nickname",
                                      isEmpty: true,
                                      maxLength: 16,
                                      radius: 15,
                                      controller: nicknameController,
                                      initValue: widget.nickname,
                                      isPass: false),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    constraints:
                                        BoxConstraints(maxHeight: size.height),
                                    child: MyTextField(
                                        width: 200,
                                        text: "BIO",
                                        isEmpty: true,
                                        radius: 15,
                                        controller: bioController,
                                        initValue: widget.bio,
                                        isPass: false),
                                  ),
                                ),
                                const Divider(
                                  color: Colors.white54,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: MyButton(
                                        width: size.width,
                                        height: 50,
                                        title: 'Change your email',
                                        color: Colors.transparent,
                                        border:
                                            Border.all(color: Colors.white54),
                                        ontap: () {
                                          print(usernameController.text);
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: MyButton(
                                        width: size.width,
                                        height: 50,
                                        title: 'Change your password',
                                        color: Colors.transparent,
                                        border:
                                            Border.all(color: Colors.white54),
                                        ontap: () {
                                          print(usernameController.text);
                                        }),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: MyButton(
                                        width: 200,
                                        height: 50,
                                        title: 'Save',
                                        color: blue,
                                        ontap: () {
                                          updateProfile(
                                              usernameController.text,
                                              nicknameController.text,
                                              bioController.text);
                                        }),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      // Profile image
                      Positioned(
                        top:
                            150.0, // (background container size) - (circle height / 2)
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          margin: const EdgeInsets.only(left: 20),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white24),
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white)),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 150,
                                  child: ClipOval(
                                    child: _file != null
                                        ? Image.memory(_file!)
                                        : Image.network(user.photoURL!,
                                            fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: InkWell(
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
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: const Icon(
                                      FontAwesomeIcons.camera,
                                      color: Color.fromARGB(255, 255, 252, 252),
                                      size: 15,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (_) {
      return Container(
        color: backgroundColor,
      );
    }
  }
}
