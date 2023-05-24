// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myblog/utils/my_font.dart';
import 'package:myblog/models/post.dart';
import 'package:myblog/models/user.dart' as model;
import 'package:myblog/screens/profile/edit_profile.dart';
import 'package:myblog/service/auth.dart';
import 'package:myblog/service/firestore_method.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/widget/poster.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final String uid;
  const Profile({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _uid = '';
  //
  late Stream<QuerySnapshot<Map<String, dynamic>>> userStream;
  //
  late Stream<QuerySnapshot<Map<String, dynamic>>> postStream;
  //
  @override
  void initState() {
    super.initState();
    _uid = widget.uid;
    userStream = FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: _uid)
        .snapshots();
    //
    postStream = FirebaseFirestore.instance.collection('Posts').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final userLogin = FirebaseAuth.instance.currentUser!;
    var coverPhotoHeight = 200.0;
    var photoHeight = 120.0;
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              //User data
              model.User user = model.User.fromSnap(
                  snapshot.data!.docs.first.data() as Map<String, dynamic>);
              //get user post data
              return StreamBuilder<QuerySnapshot>(
                stream: postStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      //list post data
                      List<Post> listAllPost = [];
                      List<Post> listPost = [];
                      List<Post> listLikesPost = [];
                      for (var element in snapshot.data!.docs) {
                        listAllPost.add(Post.fromJson(element));
                      }
                      for (int i = 0; i < listAllPost.length; i++) {
                        if (listAllPost.elementAt(i).uid.contains(user.uid!)) {
                          listPost.add(listAllPost.elementAt(i));
                        }
                        if (user.likesPosts!
                            .contains(listAllPost.elementAt(i).postId)) {
                          listLikesPost.add(listAllPost.elementAt(i));
                        }
                      }

                      //
                      return Scaffold(
                        backgroundColor: backgroundColor,
                        appBar: AppBar(
                          backgroundColor: backgroundColor,
                          title: Text(
                            user.displayName!,
                            style: titleText,
                          ),
                          actions: [
                            user.uid!.contains(userLogin.uid)
                                ? IconButton(
                                    tooltip: 'Settings',
                                    onPressed: () {},
                                    icon: const Icon(
                                        CupertinoIcons.ellipsis_vertical))
                                : Container()
                          ],
                        ),
                        body: NestedScrollView(
                          physics: const BouncingScrollPhysics(),
                          headerSliverBuilder:
                              (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              //profile
                              header(size, coverPhotoHeight, userLogin, context,
                                  user, listPost, photoHeight),
                            ];
                          },
                          // list post
                          body: ContainedTabBarView(
                              tabBarProperties: TabBarProperties(
                                  indicatorColor: blue,
                                  labelColor: blue,
                                  labelStyle: headerText,
                                  height: 53,
                                  unselectedLabelColor: unselectedTextColor,
                                  unselectedLabelStyle: headerText,
                                  background: Container(
                                    color: backgroundColor,
                                  )),
                              tabs: const [
                                Text("Posts"),
                                Text("Likes"),
                                Text("Share")
                              ],
                              views: [
                                _filterByPosts(listPost, size, userLogin),
                                _filterByLikes(
                                    listLikesPost, size, userLogin, user),
                                Container()
                              ]),
                        ),
                      );
                    }
                  }
                  return Container();
                },
              );
            }
          }
          return Container();
        },
      ),
    );
  }

  SliverToBoxAdapter header(
      Size size,
      double coverPhotoHeight,
      User userLogin,
      BuildContext context,
      model.User user,
      List<Post> listPost,
      double photoHeight) {
    final bool isLargeScreen = size.width > webScreenSize;
    return SliverToBoxAdapter(
      child: Container(
        constraints: BoxConstraints(maxHeight: size.height),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: <Widget>[
            // background image and bottom contents
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: coverPhotoHeight,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                          child: user.coverPhoto != ''
                              ? Image.network(
                                  user.coverPhoto!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: blue,
                                ))
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  child: Container(
                    alignment: Alignment.center,
                    constraints:
                        const BoxConstraints(maxHeight: double.infinity),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    decoration: const BoxDecoration(
                        border:
                            Border(bottom: BorderSide(color: Colors.white30))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Spacer(),
                            Container(
                              constraints: const BoxConstraints(
                                  maxHeight: double.infinity),
                              margin: const EdgeInsets.only(right: 5),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    //     //
                                    _uid.contains(userLogin.uid)
                                        ? Row(
                                            children: [
                                              // edit profile
                                              ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      PageTransition(
                                                          type:
                                                              PageTransitionType
                                                                  .fade,
                                                          child: EditProfile(
                                                            uid: user.uid!,
                                                            username: user
                                                                .displayName!,
                                                            nickname:
                                                                user.nickname!,
                                                            bio: user.bio!,
                                                            photoURL:
                                                                user.photoURL!,
                                                            coverPhoto: user
                                                                .coverPhoto!,
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                  microseconds:
                                                                      0)),
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                      padding:
                                                          MaterialStatePropertyAll(
                                                              EdgeInsets.all(
                                                                  isLargeScreen
                                                                      ? 15
                                                                      : 12)),
                                                      side:
                                                          const MaterialStatePropertyAll(
                                                              BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                      backgroundColor:
                                                          const MaterialStatePropertyAll(
                                                              blue)),
                                                  child: Text(
                                                    "Edit profile",
                                                    style: bodyText,
                                                  )),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        padding:
                                                            MaterialStatePropertyAll(
                                                                EdgeInsets.all(
                                                                    isLargeScreen
                                                                        ? 15
                                                                        : 12)),
                                                        side: const MaterialStatePropertyAll(
                                                            BorderSide(
                                                                color: Colors
                                                                    .white)),
                                                        backgroundColor:
                                                            const MaterialStatePropertyAll(
                                                                Colors
                                                                    .transparent)),
                                                    onPressed: () async {
                                                      await AuthMethods()
                                                          .signOut()
                                                          .then((value) =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop());
                                                    },
                                                    child: Text(
                                                      "Sign out",
                                                      style: bodyText,
                                                    )),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  await FireStoreMethod()
                                                      .followUser(userLogin.uid,
                                                          user.uid!);
                                                },
                                                style: ButtonStyle(
                                                    padding:
                                                        MaterialStatePropertyAll(
                                                            EdgeInsets.all(
                                                                isLargeScreen
                                                                    ? 15
                                                                    : 12)),
                                                    side:
                                                        const MaterialStatePropertyAll(
                                                            BorderSide(
                                                                color: Colors
                                                                    .white)),
                                                    backgroundColor:
                                                        const MaterialStatePropertyAll(
                                                            Colors
                                                                .transparent)),
                                                child: user.followers!
                                                        .contains(userLogin.uid)
                                                    ? Text('Unfollow',
                                                        style: bodyText)
                                                    : Text("Follow",
                                                        style: bodyText),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15),
                                                child: ElevatedButton.icon(
                                                    onPressed: () {},
                                                    style: ButtonStyle(
                                                        padding:
                                                            MaterialStatePropertyAll(
                                                                EdgeInsets.all(
                                                                    isLargeScreen
                                                                        ? 15
                                                                        : 12)),
                                                        side: const MaterialStatePropertyAll(
                                                            BorderSide(
                                                                color: Colors
                                                                    .white)),
                                                        backgroundColor:
                                                            const MaterialStatePropertyAll(
                                                                blue)),
                                                    icon: const Icon(
                                                      FontAwesomeIcons
                                                          .solidMessage,
                                                      size: 13,
                                                    ),
                                                    label: Text('Message',
                                                        style: bodyText)),
                                              )
                                            ],
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 15, top: size.height * 0.05),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.start,
                                text: TextSpan(
                                    text: user.displayName,
                                    style: bodyText,
                                    children: [
                                      TextSpan(
                                        text: user.nickname != ""
                                            ? " ( ${user.nickname} )"
                                            : "",
                                        style: smallText,
                                      )
                                    ]),
                              ),
                              Text(user.email!,
                                  textAlign: TextAlign.start, style: bodyText),
                              SelectableLinkify(
                                onOpen: (link) async {
                                  if (await canLaunchUrl(Uri.parse(link.url))) {
                                    await launchUrl(Uri.parse(link.url),
                                        mode: LaunchMode
                                            .externalNonBrowserApplication);
                                  } else {
                                    throw 'Could not launch $link';
                                  }
                                },
                                text: user.bio!,
                                style: bodyText,
                                linkStyle: linkText,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                          text: listPost.length.toString(),
                                          style: bodyText,
                                          children: [
                                            TextSpan(
                                                text: ' Posts', style: bodyText)
                                          ]),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 17.0),
                                      child: RichText(
                                        text: TextSpan(
                                            text: user.followers!.length
                                                .toString(),
                                            style: bodyText,
                                            children: [
                                              TextSpan(
                                                  text: ' Followers',
                                                  style: bodyText)
                                            ]),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          text:
                                              user.following!.length.toString(),
                                          style: bodyText,
                                          children: [
                                            TextSpan(
                                                text: ' Following',
                                                style: bodyText)
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            // Profile image
            Positioned(
              top: coverPhotoHeight -
                  (photoHeight /
                      2), // (background container size) - (circle height / 2)
              child: Container(
                height: photoHeight,
                margin: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey)),
                child: ClipOval(
                    child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Image.network(
                    user.photoURL!,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, loadingProgress) {
                      //loading image
                      if (loadingProgress == null)
                        // ignore: curly_braces_in_flow_control_structures
                        return child;
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.white60,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }

//Body
  Widget _filterByPosts(List<Post> listPost, Size size, User userLogin) {
    return Container(
      child: listPost.isNotEmpty
          ? Center(
              child: SizedBox(
                width: size.width > webScreenSize ? 600 : size.width,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: listPost.length + 1,
                    itemBuilder: (context, index) {
                      if (index < listPost.length) {
                        Post post = listPost.elementAt(index);
                        return Poster(post: post);
                      } else {
                        return Center(
                            child: Text(
                          'No more data',
                          style: bodyText,
                        ));
                      }
                    }),
              ),
            )
          : Container(
              constraints: BoxConstraints(maxHeight: size.height),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No posts yet',
                      style: headerText,
                    ),
                  ),
                  Text(
                    _uid.contains(userLogin.uid)
                        ? 'Why not create one ?'
                        : "Looks like this person hasn't posted anything yet.",
                    style: bodyText,
                  )
                ],
              ),
            ),
    );
  }

  //
  Widget _filterByLikes(
      List<Post> listLikesPosts, Size size, User userLogin, model.User user) {
    return Container(
      child: listLikesPosts.isNotEmpty
          ? Center(
              child: SizedBox(
                width: size.width > webScreenSize ? 600 : size.width,
                child: ListView.builder(
                    shrinkWrap: false,
                    physics: const BouncingScrollPhysics(),
                    itemCount: listLikesPosts.length + 1,
                    itemBuilder: (context, index) {
                      if (index < listLikesPosts.length) {
                        Post post = listLikesPosts.elementAt(index);
                        return Poster(post: post);
                      } else {
                        return Center(
                            child: Text(
                          'No more data',
                          style: bodyText,
                        ));
                      }
                    }),
              ),
            )
          : SizedBox(
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _uid.contains(userLogin.uid)
                          ? 'You don’t have any likes yet'
                          : '@${user.displayName} hasn’t liked any Posts',
                      style: headerText,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 60),
                    child: Text(
                      _uid.contains(userLogin.uid)
                          ? 'Tap the heart on any Posts to show it some love.\nWhen you do, it’ll show up here.'
                          : "When they do, those Posts will show up here.",
                      style: bodyText,
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
