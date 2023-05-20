import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myblog/models/user.dart' as model;
import 'package:myblog/screens/add_post.dart';
import 'package:myblog/screens/home/home_screen.dart';
import 'package:myblog/screens/profile/profile.dart';
import 'package:myblog/screens/search/search.dart';
import 'package:myblog/screens/settings/setting.dart';
import 'package:myblog/utils/global_variable.dart';
import 'package:myblog/utils/my_color.dart';
import 'package:myblog/utils/my_font.dart';
import 'package:page_transition/page_transition.dart';

import '../models/UserController.dart';

class ResponsiveLayout extends StatefulWidget {
  const ResponsiveLayout({
    super.key,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserController userController = Get.put(UserController());
    await userController.refreshUser();
  }

  //
  int _currentIndex = 0;
  final home = GlobalKey<NavigatorState>();
  final search = GlobalKey<NavigatorState>();
  final message = GlobalKey<NavigatorState>();
  final notification = GlobalKey<NavigatorState>();
  final profile = GlobalKey<NavigatorState>();
  final setting = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final bool isMediumScreen = size.width > 800;
    final bool isLargeScreen = size.width > 1000;
    return Scaffold(
      appBar: size.width > webScreenSize
          ? AppBar(
              backgroundColor: backgroundColor,
              leading: const Padding(
                padding: EdgeInsets.all(10.0),
                child: FlutterLogo(
                  size: 12,
                ),
              ),
            )
          : null,
      backgroundColor: backgroundColor,
      floatingActionButton: size.width < webScreenSize
          ? Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  shape: BoxShape.circle),
              child: FloatingActionButton(
                heroTag: 'addPost',
                tooltip: 'Add post',
                backgroundColor: blue,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        // ignore: prefer_const_constructors
                        return Dialog.fullscreen(
                          child: const AddPost(),
                        );
                      });
                },
                child: const Icon(
                  FontAwesomeIcons.plus,
                  color: Colors.white,
                ),
              ),
            )
          : null,
      bottomNavigationBar: size.width < webScreenSize ? _bottomBar() : null,
      body: Row(
        children: [
          size.width > webScreenSize
              ? Expanded(
                  flex: size.width <= 800 ? 1 : 2,
                  child: _slideBar(size, isMediumScreen, context),
                )
              : Container(),
          Expanded(
            flex: 3,
            child: IndexedStack(
              index: _currentIndex,
              children: <Widget>[
                Navigator(
                  key: home,
                  onGenerateRoute: (route) => MaterialPageRoute(
                    settings: route,
                    builder: (context) => const HomeScreen(),
                  ),
                ),
                Navigator(
                  key: search,
                  onGenerateRoute: (route) => MaterialPageRoute(
                    settings: route,
                    builder: (context) => const Search(),
                  ),
                ),
                Navigator(
                  key: message,
                  onGenerateRoute: (route) => MaterialPageRoute(
                    settings: route,
                    builder: (context) => Container(),
                  ),
                ),
                Navigator(
                  key: notification,
                  onGenerateRoute: (route) => MaterialPageRoute(
                    settings: route,
                    builder: (context) => Container(),
                  ),
                ),
                Navigator(
                  key: profile,
                  onGenerateRoute: (route) => MaterialPageRoute(
                    settings: route,
                    builder: (context) => Profile(
                      uid: FirebaseAuth.instance.currentUser!.uid,
                    ),
                  ),
                ),
                size.width > webScreenSize
                    ? Navigator(
                        key: setting,
                        onGenerateRoute: (route) => MaterialPageRoute(
                          settings: route,
                          builder: (context) => const SettingsApp(),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          isLargeScreen
              ? Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: secondColor,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Container _bottomBar() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white))),
      child: BottomNavigationBar(
          backgroundColor: backgroundColor,
          selectedItemColor: blue,
          type: BottomNavigationBarType.shifting,
          //  unselectedItemColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (home.currentState!.canPop()) {
                home.currentState!.pushAndRemoveUntil(
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: const HomeScreen(),
                        duration: const Duration(microseconds: 0)),
                    (route) => false);
              }
              if (search.currentState!.canPop()) {
                search.currentState!.pushAndRemoveUntil(
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: const Search(),
                        duration: const Duration(microseconds: 0)),
                    (route) => false);
              }
              if (message.currentState!.canPop()) {
                message.currentState!.pushAndRemoveUntil(
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: Container(),
                        duration: const Duration(microseconds: 0)),
                    (route) => false);
              }
              if (notification.currentState!.canPop()) {
                notification.currentState!.pushAndRemoveUntil(
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: Container(),
                        duration: const Duration(microseconds: 0)),
                    (route) => false);
              }
              if (profile.currentState!.canPop()) {
                profile.currentState!.pushAndRemoveUntil(
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: Profile(
                          uid: FirebaseAuth.instance.currentUser!.uid,
                        ),
                        duration: const Duration(microseconds: 0)),
                    (route) => false);
              }
            });
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: backgroundColor,
              icon: Icon(
                CupertinoIcons.house,
                size: 20,
              ),
              activeIcon: Icon(
                CupertinoIcons.house_fill,
                size: 20,
              ),
              label: "Home",
            ),

            /// Likes
            BottomNavigationBarItem(
              backgroundColor: backgroundColor,
              icon: Icon(
                CupertinoIcons.search,
                size: 20,
              ),
              label: "Search",
            ),

            /// Search
            BottomNavigationBarItem(
              backgroundColor: backgroundColor,
              icon: Icon(
                CupertinoIcons.chat_bubble,
                size: 20,
              ),
              activeIcon: Icon(
                CupertinoIcons.chat_bubble_fill,
                size: 20,
              ),
              label: "Message",
            ),
            BottomNavigationBarItem(
              backgroundColor: backgroundColor,
              icon: Icon(
                CupertinoIcons.bell,
                size: 20,
              ),
              activeIcon: Icon(
                CupertinoIcons.bell_solid,
                size: 20,
              ),
              label: "Notification",
            ),

            /// Profile
            BottomNavigationBarItem(
              backgroundColor: backgroundColor,
              icon: Icon(
                CupertinoIcons.person,
                size: 20,
              ),
              activeIcon: Icon(
                CupertinoIcons.person_solid,
                size: 20,
              ),
              label: "Profile",
            ),
          ]),
    );
  }

  Widget _slideBar(Size size, bool isMediumScreen, BuildContext context) {
    return Column(
      children: [
        //slide bar
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: secondColor,
                    borderRadius: BorderRadius.circular(15)),
              ),
              SizedBox(
                width: 200,
                height: 550,
                child: NavigationRail(
                    backgroundColor: Colors.transparent,
                    groupAlignment: -1,
                    extended: isMediumScreen,
                    onDestinationSelected: (value) {
                      setState(() {
                        _currentIndex = value;
                        if (home.currentState!.canPop()) {
                          home.currentState!.pushAndRemoveUntil(
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const HomeScreen(),
                                  duration: const Duration(microseconds: 0)),
                              (route) => false);
                        }
                        if (search.currentState!.canPop()) {
                          search.currentState!.pushAndRemoveUntil(
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: const Search(),
                                  duration: const Duration(microseconds: 0)),
                              (route) => false);
                        }
                        if (message.currentState!.canPop()) {
                          message.currentState!.pushAndRemoveUntil(
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Container(),
                                  duration: const Duration(microseconds: 0)),
                              (route) => false);
                        }
                        if (notification.currentState!.canPop()) {
                          notification.currentState!.pushAndRemoveUntil(
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Container(),
                                  duration: const Duration(microseconds: 0)),
                              (route) => false);
                        }
                        if (profile.currentState!.canPop()) {
                          profile.currentState!.pushAndRemoveUntil(
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: Profile(
                                    uid: FirebaseAuth.instance.currentUser!.uid,
                                  ),
                                  duration: const Duration(microseconds: 0)),
                              (route) => false);
                        }
                      });
                    },
                    trailing: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            backgroundColor: Colors.transparent,
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0)),
                            child: const AddPost(),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 50,
                        margin: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            color: blue,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              FontAwesomeIcons.plus,
                              color: Colors.white,
                              size: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('Add Posts', style: headerText),
                            )
                          ],
                        ),
                      ),
                    ),
                    unselectedIconTheme:
                        const IconThemeData(size: 25, color: mainTextColor),
                    unselectedLabelTextStyle: GoogleFonts.nunitoSans(
                        color: mainTextColor, fontSize: 20),
                    selectedIconTheme:
                        const IconThemeData(size: 25, color: blue),
                    selectedLabelTextStyle: GoogleFonts.nunitoSans(
                      color: blue,
                      fontSize: 22,
                    ),
                    destinations: const [
                      NavigationRailDestination(
                          icon: Icon(CupertinoIcons.house),
                          selectedIcon: Icon(CupertinoIcons.house_fill),
                          label: Text(
                            'Home',
                          )),
                      NavigationRailDestination(
                          icon: Icon(CupertinoIcons.search),
                          selectedIcon: Icon(CupertinoIcons.search),
                          label: Text('Search')),
                      NavigationRailDestination(
                          icon: Icon(CupertinoIcons.chat_bubble),
                          selectedIcon: Icon(CupertinoIcons.chat_bubble_fill),
                          label: Text('Message')),
                      NavigationRailDestination(
                          icon: Icon(CupertinoIcons.bell),
                          selectedIcon: Icon(CupertinoIcons.bell_solid),
                          label: Text('Notification')),
                      NavigationRailDestination(
                          icon: Icon(CupertinoIcons.person),
                          selectedIcon: Icon(CupertinoIcons.person_solid),
                          label: Text('Profile')),
                      NavigationRailDestination(
                          icon: Icon(CupertinoIcons.gear),
                          selectedIcon: Icon(CupertinoIcons.gear_solid),
                          label: Text('Settings')),
                    ],
                    selectedIndex: _currentIndex),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
