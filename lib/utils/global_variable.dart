import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:myblog/models/UserController.dart';
import 'package:myblog/screens/home/home_screen.dart';
import 'package:myblog/screens/profile/profile.dart';
import 'package:myblog/screens/search/search.dart';
import 'package:myblog/utils/my_color.dart';

const webScreenSize = 600;

var userController = UserController.instance;
List<Widget> pages = [
  const HomeScreen(),
  const Search(),
  Container(),
  Container(),
  Profile(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
