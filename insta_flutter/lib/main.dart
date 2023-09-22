import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_flutter/providers/user_provider.dart';
import 'package:insta_flutter/responsive/mobile_Screen_Layout.dart';
import 'package:insta_flutter/responsive/responsive.dart';
import 'package:insta_flutter/screens/login_screen_state.dart';
import 'package:insta_flutter/screens/signup_screen.dart';
import 'package:insta_flutter/utils/colors.dart';
import 'package:insta_flutter/responsive/desktop_layout.dart';
import 'package:firebase_core/firebase_core.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:provider/provider.dart";

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],

      child: MaterialApp(
        title: 'InstaClone',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active){
              if(snapshot.hasData){
                return const ResponsiveLayout(desktopLayout: DesktopLayout(), mobileLayout: MobileLayout());
              } else if (snapshot.hasError){
                return const Center(child: Text("Something went wrong"));
              }
            }
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(color: primaryColor));
            }

            return const LoginScreen();
          })
      )
    );
  }
}
