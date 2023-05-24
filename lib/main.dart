import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_get/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myblog/auth_state.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      routes: {
        '/main': (context) => const AuthState(),
      },
      initialRoute: '/main',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GiphyGetUILocalizations.delegate
      ],
      supportedLocales: [
        Get.deviceLocale!,
      ],
      home: const AuthState(),
    );
  }
}
