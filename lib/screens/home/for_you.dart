import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myblog/models/post.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/widget/poster.dart';

class ForYou extends StatefulWidget {
  const ForYou({super.key});

  @override
  State<ForYou> createState() => _ForYouState();
}

class _ForYouState extends State<ForYou> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var size = MediaQuery.of(context).size;
    final userLogin = FirebaseAuth.instance.currentUser!;
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              List<Post> listPost = [];
              for (var element in snapshot.data!.docs) {
                listPost.add(Post.fromJson(element));
              }
              return Center(
                  child: SizedBox(
                      width: size.width > webScreenSize ? 600 : size.width,
                      child: ListView.builder(
                          shrinkWrap: true,
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
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
