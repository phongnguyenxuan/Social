import 'package:emoji_dialog_picker/emoji_dialog_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:myblog/models/post.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/utils/utils.dart';
import 'package:myblog/widget/button.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  Uint8List? _file;
  // ignore: non_constant_identifier_names
  String image_url = "";
  GiphyGif? mygif;
  //
  bool isGif = false;
  //
  late TextEditingController titleController;
  @override
  void initState() {
    titleController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  //pick image
  _pickImage() async {
    try {
      Uint8List file = await pickImage(ImageSource.gallery, context, true);
      // Uint8List bytes;
      setState(() {
        _file = file;
      });
    } on PlatformException catch (_) {}
    setState(() {
      isGif = false;
    });
  }

  //pick gif
  pickGif() async {
    try {
      mygif = await GiphyGet.getGif(
        context: context,
        apiKey: '2AZIow93MRatjFnIgEkCkkrBLY0z3bGE',
        lang: GiphyLanguage.english,
      );
      if (mygif != null) {
        setState(() {
          image_url = "https://i.giphy.com/media/${mygif!.id}/200.gif";
        });
      } else {
        image_url = "";
      }
    } on PlatformException catch (_) {}
    setState(() {
      isGif = true;
    });
  }

  //upload data
  void uploadData(String uid) async {
    try {
      var ref = FirebaseFirestore.instance.collection('Posts');
      //
      var postId = ref.doc().id;
      var title = titleController.text;
      //
      //loading
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: Lottie.asset('assets/lotties/loading.json'));
          });
      if (isGif == false) {
        if (_file != null) {
          //upload image
          var storage = FirebaseStorage.instance;
          var refS = storage.ref("Posts/$postId").child("/image");
          var upLoad = refS.putData(_file!);
          await upLoad.whenComplete(() async {
            //get url image
            var url = await refS.getDownloadURL();
            image_url = url.toString();
          });
        } else {
          image_url = "";
        }
        Post newPost = Post(
          uid: uid,
          title: title,
          likes: [],
          postImage: image_url,
          postId: postId,
          datePublished: DateTime.now(),
          user: userController.getUser,
        );
        await ref
            .doc(postId)
            .set(newPost.toJson())
            .then((value) => Navigator.of(context).pop());
      }
      if (isGif == true) {
        Post newPost = Post(
            uid: uid,
            title: title,
            likes: [],
            postImage: image_url,
            postId: postId,
            datePublished: DateTime.now(),
            user: userController.getUser);
        await ref
            .doc(postId)
            .set(newPost.toJson())
            .then((value) => Navigator.of(context).pop());
      }
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    try {
      var size = MediaQuery.of(context).size;
      final userLogin = userController.getUser;
      return Container(
        // width: size.width,
        constraints: BoxConstraints(
            maxWidth: size.width < webScreenSize ? size.width : size.width / 2),
        padding: const EdgeInsets.all(20),
        color: backgroundColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: Tooltip(
                    message: 'Exit',
                    child: InkWell(
                      onTap: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(
                          FontAwesomeIcons.xmark,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )),
              Center(
                child: Container(
                  width: 500,
                  height: size.height / 1.7,
                  padding: const EdgeInsets.all(20),
                  constraints: BoxConstraints(minHeight: size.height / 1.7),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(10)),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.grey)),
                              child: CircleAvatar(
                                radius: 21,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                    child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: Image.network(
                                          userLogin.photoURL!,
                                          fit: BoxFit.cover,
                                        ))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                userLogin.displayName!,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.white, fontSize: 13),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: titleController,
                            maxLines: 10,
                            style: GoogleFonts.nunitoSans(
                                color: Colors.white, fontSize: 15),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                hintText: "what are the thinking ?",
                                hintStyle: GoogleFonts.nunitoSans(
                                    color: Colors.white, fontSize: 15),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Colors.white54)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Colors.white54)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                        color: Colors.white54))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: size.width,
                            height: 70,
                            padding: const EdgeInsets.all(20),
                            constraints: BoxConstraints(maxHeight: size.height),
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                border: Border.all(color: Colors.white54),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Text(
                                  "add to your posts",
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.white, fontSize: 15),
                                ),
                                const Spacer(),
                                EmojiButton(
                                  emojiPickerView: EmojiPickerView(
                                      backgroundColor: backgroundColor,
                                      onEmojiSelected: (String emoji) {
                                        titleController.text += emoji;
                                      }),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      FontAwesomeIcons.faceSmile,
                                      color: Colors.yellowAccent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    _pickImage();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      FontAwesomeIcons.image,
                                      color: Colors.greenAccent,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    pickGif();
                                  },
                                  child: const Icon(
                                    Icons.gif_outlined,
                                    color: Colors.orangeAccent,
                                    size: 35,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        //Media
                        Container(
                            child: _file != null || image_url != ""
                                ? Stack(
                                    children: [
                                      isGif
                                          ? Center(
                                              child: Image.network(
                                                image_url,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  //loading image
                                                  if (loadingProgress == null)
                                                    // ignore: curly_braces_in_flow_control_structures
                                                    return child;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white60,
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : Center(child: Image.memory(_file!)),
                                      Align(
                                        alignment: Alignment.topRight,
                                        // delete image
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                image_url = "";
                                                _file = null;
                                              });
                                            },
                                            icon: const Icon(
                                              FontAwesomeIcons.circleXmark,
                                              color: Colors.white,
                                              shadows: [
                                                Shadow(
                                                    color: Colors.black,
                                                    blurRadius: 3)
                                              ],
                                            )),
                                      )
                                    ],
                                  )
                                : null),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Center(
                    child: MyButton(
                  width: 200,
                  height: 50,
                  title: 'Post',
                  color: blue,
                  ontap: () {
                    uploadData(userLogin.uid!);
                  },
                )),
              ),
            ],
          ),
        ),
      );
    } catch (_) {
      return Container();
    }
  }
}
