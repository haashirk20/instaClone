import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:insta_flutter/utils/colors.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children:[
              //svg image
              SvgPicture.asset("assets/images/instagram.svg", color: primaryColor, height: 64),
              //text field input for user/email
              const SizedBox(height: 64),
              //text field input for password
              const SizedBox(height: 64),
              //login button
              //signup transition
            ])
        )
      )
    );
  }
}