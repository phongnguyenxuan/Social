import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myblog/responsive/responsive_layout.dart';
import 'package:myblog/screens/login.dart';

class AuthState extends StatefulWidget {
  const AuthState({super.key});

  @override
  State<AuthState> createState() => _AuthStateState();
}

class _AuthStateState extends State<AuthState> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const ResponsiveLayout();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
