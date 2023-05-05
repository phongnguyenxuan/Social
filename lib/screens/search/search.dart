import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myblog/models/post.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/utils/my_font.dart';
import 'package:myblog/widget/poster.dart';
import 'package:myblog/widget/textfield.dart';
import 'package:myblog/models/user.dart' as model;
import 'package:myblog/widget/usercard.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController searchController = TextEditingController();

  List<Post> searchPostResult = [];
  List<Post> allPosts = [];
  //Posts
  void getAllPosts() async {
    final result = await FirebaseFirestore.instance.collection('Posts').get();
    if (mounted) {
      setState(() {
        allPosts =
            List<Post>.from(result.docs.map((e) => Post.fromJson(e))).toList();
      });
    }
  }

  List<model.User> searchUserResult = [];
  List<model.User> allUser = [];
  //User
  void getAllUser() async {
    final result = await FirebaseFirestore.instance.collection('users').get();
    if (mounted) {
      setState(() {
        allUser = List<model.User>.from(
            result.docs.map((e) => model.User.fromSnap(e.data()))).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getAllPosts();
    getAllUser();
    searchController.addListener(() {
      //clear list
      searchUserResult.clear();
      searchPostResult.clear();
      if (searchController.text.isNotEmpty) {
        if (!mounted) return;
        setState(() {});
        for (int i = 0; i < allPosts.length; i++) {
          //convert to lowercase and remove whitespace
          String title =
              allPosts.elementAt(i).title.toLowerCase().removeAllWhitespace;
          if (title.contains(
              searchController.text.toLowerCase().removeAllWhitespace)) {
            setState(() {
              searchPostResult.add(allPosts.elementAt(i));
            });
          }
        }
        for (int i = 0; i < allUser.length; i++) {
          //convert to lowercase and remove whitespace
          String displayName = allUser
              .elementAt(i)
              .displayName!
              .toLowerCase()
              .removeAllWhitespace;
          if (displayName.contains(
              searchController.text.toLowerCase().removeAllWhitespace)) {
            setState(() {
              searchUserResult.add(allUser.elementAt(i));
            });
          }
        }
      } else {
        setState(() {
          searchPostResult = [];
          searchUserResult = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          "Search",
          style: titleText,
        ),
      ),
      body: Center(
        child: SizedBox(
          width: size.width > webScreenSize ? 700 : size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: searchBar(),
              ),
              Expanded(
                child: ContainedTabBarView(
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
                  tabs: const [Text("People"), Text("Posts")],
                  views: [
                    searchByUser(),
                    searchByPosts(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  MyTextField searchBar() {
    return MyTextField(
      height: 20,
      width: 300,
      text: "Search",
      icon: const Icon(
        FontAwesomeIcons.magnifyingGlass,
        color: Colors.white,
        size: 18,
      ),
      controller: searchController,
      radius: 90,
      isPass: false,
    );
  }

  Widget searchByUser() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
                searchUserResult.isNotEmpty
                    ? 'Found ${searchUserResult.length} results for "${searchController.text}" search'
                    : '',
                style: bodyText),
          ),
          Center(
              child: searchController.text != ''
                  ? searchUserResult.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchUserResult.length,
                          itemBuilder: (context, index) {
                            return UserCard(
                                user: searchUserResult.elementAt(index));
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.asset('assets/images/search.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No results found',
                                style: headerText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                  "Sorry, there are not user for '${searchController.text}'.",
                                  style: bodyText),
                            )
                          ],
                        )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset('assets/images/telescope.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Searching something',
                            style: headerText,
                          ),
                        ),
                      ],
                    )),
        ],
      ),
    );
  }

  Widget searchByPosts() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
                searchPostResult.isNotEmpty
                    ? 'Found ${searchPostResult.length} results for "${searchController.text}" search'
                    : '',
                style: bodyText),
          ),
          Center(
              child: searchController.text != ''
                  ? searchPostResult.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchPostResult.length,
                          itemBuilder: (context, index) {
                            return Poster(
                                post: searchPostResult.elementAt(index));
                          },
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 150,
                              height: 150,
                              child: Image.asset('assets/images/search.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No results found',
                                style: headerText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "Sorry, there are not Posts for ${searchController.text}.",
                                style: bodyText,
                              ),
                            )
                          ],
                        )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset('assets/images/telescope.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Searching something',
                            style: headerText,
                          ),
                        ),
                      ],
                    )),
        ],
      ),
    );
  }
}
