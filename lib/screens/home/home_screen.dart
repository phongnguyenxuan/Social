import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myblog/screens/home/following_screen.dart';
import 'package:myblog/screens/home/for_you.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/utils/my_font.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  //
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Home", style: titleText),
      ),
      body: Center(
        child: SizedBox(
          width: size.width > webScreenSize ? 700 : size.width,
          child: ContainedTabBarView(
              tabBarProperties: TabBarProperties(
                  indicatorColor: blue,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorWeight: 4,
                  labelColor: blue,
                  labelStyle: headerText,
                  height: 53,
                  unselectedLabelColor: unselectedTextColor,
                  unselectedLabelStyle: headerText,
                  background: Container(
                    decoration: const BoxDecoration(
                        color: backgroundColor,
                        border:
                            Border(bottom: BorderSide(color: Colors.white54))),
                  )),
              tabs: const [
                Text(
                  "For you",
                ),
                Text(
                  "Following",
                )
              ],
              views: [
                const ForYou(),
                FollowingScr(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                )
              ]),
        ),
      ),
    ));
  }
}
