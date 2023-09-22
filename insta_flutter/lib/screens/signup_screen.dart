import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import 'package:insta_flutter/responsive/desktop_layout.dart';
import 'package:insta_flutter/responsive/mobile_screen_layout.dart';
import 'package:insta_flutter/responsive/responsive.dart';
import "package:insta_flutter/resources/auth_methods.dart";
import "package:insta_flutter/screens/login_screen_state.dart";
import "package:insta_flutter/utils/colors.dart";
import "package:insta_flutter/widgets/text_field_input.dart";
import "package:insta_flutter/utils/utils.dart";
import "package:image_picker/image_picker.dart";

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  void selectImage() async {
    Uint8List lis = await pickImage(ImageSource.gallery);
    setState(() {
      _image = lis;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        userName: _userNameController.text,
        bio: _bioController.text,
        file: _image!);
    
    if (res != "success") {
      showSnackBar(res, context);
    } else{
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ResponsiveLayout(desktopLayout: DesktopLayout(), mobileLayout: MobileLayout())));
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen()));
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
                      const SizedBox(height: 16),
                      //circular widget to show icon
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundImage: NetworkImage(
                                      "https://cdn141.picsart.com/357697367045201.jpg"),
                                ),
                          Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                  onPressed: selectImage,
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                  ))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      //text field input for user
                      TextFieldInput(
                        hintText: "Enter your username",
                        textInputType: TextInputType.text,
                        textEditingController: _userNameController,
                      ),
                      //text field input for user/email
                      const SizedBox(height: 16),
                      TextFieldInput(
                        hintText: "Enter your email",
                        textInputType: TextInputType.emailAddress,
                        textEditingController: _emailController,
                      ),

                      const SizedBox(height: 16),
                      //text field input for password
                      TextFieldInput(
                          hintText: "Enter your password",
                          textInputType: TextInputType.emailAddress,
                          textEditingController: _passwordController,
                          isPass: true),
                      const SizedBox(height: 16),
                      //text field input for bio
                      TextFieldInput(
                        hintText: "Enter your bio",
                        textInputType: TextInputType.text,
                        textEditingController: _bioController,
                      ),
                      //text field input for user/email
                      const SizedBox(height: 16),
                      //login button

                      InkWell(
                        onTap: signUpUser,
                        child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              color: blueColor,
                            ),
                            child: _isLoading ? const Center(
                              child: CircularProgressIndicator(color: primaryColor),
                            ): const Text("Sign up")),
                      ),
                      const SizedBox(height: 16),
                      Flexible(flex: 10, child: Container()),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: const Text("Have an account? "),
                            ),
                            GestureDetector(
                              onTap: navigateToLogin,
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                child: const Text("Log in!",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            )
                          ])
                    ]))));
  }
}
