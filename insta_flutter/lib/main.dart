import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_flutter/reponsive/mobile_Screen_Layout.dart';
import 'package:insta_flutter/reponsive/responsive.dart';
import 'package:insta_flutter/screens/login_screen_state.dart';
import 'package:insta_flutter/screens/signup_screen.dart';
import 'package:insta_flutter/utils/colors.dart';
import 'package:insta_flutter/reponsive/desktop_layout.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCzf0qA8QCZUDcJj_0JMAynR0eSJ25rzHI",
            appId: "1:1060080970683:web:2a2e71fc03b763715c329e",
            messagingSenderId: "1060080970683",
            projectId: "instaclone-45c95",
            storageBucket: "instaclone-45c95.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InstaClone',
      theme: ThemeData.dark()
          .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
      //home: const ResponsiveLayout(desktopLayout: DesktopLayout(), mobileLayout: MobileLayout() ),
      home: SignupScreen(),
    );
  }
}
