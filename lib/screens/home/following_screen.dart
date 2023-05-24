// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import 'package:myblog/models/post.dart';
import 'package:myblog/models/user.dart' as model;
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/widget/poster.dart';

class FollowingScr extends StatefulWidget {
  final String uid;
  const FollowingScr({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<FollowingScr> createState() => _FollowingScrState();
}

class _FollowingScrState extends State<FollowingScr>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: widget.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //User data
          model.User user = model.User.fromSnap(
              snapshot.data!.docs.first.data() as Map<String, dynamic>);
          updateKeepAlive();
          if (user.following!.isNotEmpty) {
            return Scaffold(
                backgroundColor: backgroundColor,
                body: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Posts')
                      .where("uid", whereIn: user.following)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Container(
                          width: 200, height: 200, color: Colors.red);
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: Lottie.asset('assets/lotties/loading.json'));
                    }
                    if (snapshot.hasData) {
                      List<Post> listPost = [];
                      for (var element in snapshot.data!.docs) {
                        listPost.add(Post.fromJson(element));
                      }
                      if (listPost.isNotEmpty) {
                        return Center(
                            child: SizedBox(
                                width: size.width > webScreenSize
                                    ? 600
                                    : size.width,
                                child: ListView.builder(
                                    shrinkWrap: false,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: listPost.length,
                                    itemBuilder: (context, index) {
                                      Post post = listPost.elementAt(index);
                                      return Poster(post: post);
                                    })));
                      }
                      return Container();
                    }
                    return Container();
                  },
                ));
          }
          return SizedBox(
            width: size.width > webScreenSize ? 600 : size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200,
                    height: 200,
                    child: Image.asset("assets/images/meteorite.png")),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "No Post Found",
                    style: GoogleFonts.nunitoSans(
                        color: Colors.white54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "You're not following any account yet.",
                  style: GoogleFonts.nunitoSans(
                      color: Colors.white54,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
