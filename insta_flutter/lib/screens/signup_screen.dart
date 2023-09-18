import "package:flutter/material.dart";
import "package:flutter_svg/flutter_svg.dart";
import "package:insta_flutter/utils/colors.dart";
import "package:insta_flutter/widgets/text_field_input.dart";

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

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _userNameController.dispose();
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
                      const SizedBox(height: 24),
                      //circular widget to show icon
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1692698921100-e31dc7453d4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80"),
                          ),
                          Positioned(bottom: -10, left: 80, child: IconButton(onPressed: () {}, icon: Icon(Icons.add_a_photo,))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      //text field input for user
                      TextFieldInput(
                        hintText: "Enter your username",
                        textInputType: TextInputType.text,
                        textEditingController: _userNameController,
                      ),
                      //text field input for user/email
                      const SizedBox(height: 24),
                      TextFieldInput(
                        hintText: "Enter your email",
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
                      //text field input for bio
                      TextFieldInput(
                        hintText: "Enter your bio",
                        textInputType: TextInputType.text,
                        textEditingController: _bioController,
                      ),
                      //text field input for user/email
                      const SizedBox(height: 24),
                      //login button
                      Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            color: blueColor,
                          ),
                          child: const Text("Sign up")),
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
                              onTap: () {},
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
