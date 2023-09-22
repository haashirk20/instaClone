import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import 'package:insta_flutter/responsive/desktop_layout.dart';
import 'package:insta_flutter/responsive/mobile_screen_layout.dart';
import 'package:insta_flutter/responsive/responsive.dart';
import "package:insta_flutter/utils/colors.dart";
import "package:insta_flutter/utils/utils.dart";
import "package:insta_flutter/widgets/text_field_input.dart";
import "package:insta_flutter/resources/auth_methods.dart";
import "package:insta_flutter/screens/signup_screen.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async{
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if(res == "success"){
      //navigate to home screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveLayout(desktopLayout: DesktopLayout(), mobileLayout: MobileLayout())));
    }
    else{
      //show error
      showSnackBar(res, context);
    }
        setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(flex: 1, child: Container()),
                      //svg image
                      SvgPicture.asset("assets/ic_instagram.svg",
                          colorFilter: const ColorFilter.mode(
                              primaryColor, BlendMode.srcIn),
                          height: 64),
                      //text field input for user/email
                      const SizedBox(height: 24),
                      TextFieldInput(
                        hintText: "Enter your Username or Email",
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                      ),

                      const SizedBox(height: 24),
                      //text field input for password
                      TextFieldInput(
                          hintText: "Enter your password",
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _passwordController,
                          isPass: true),

                      const SizedBox(height: 24),
                      //login button
                      InkWell(
                          onTap: loginUser,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))
                                  ),
                              color: blueColor,
                            ),
                            child: _isLoading? const Center(child: CircularProgressIndicator(color: primaryColor)): const Text("Log in")
                          ),
                      ),
                      const SizedBox(height: 24),
                      Flexible(flex: 2, child: Container()),
                      //signup transition
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text("Don't have an account? "),
                            ),
                            GestureDetector(
                              onTap: navigateToSignUp,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const Text("Sign up!",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            )
                          ])
                    ]))));
  }
}
