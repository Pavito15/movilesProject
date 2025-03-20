import 'package:flutter/material.dart';
import 'package:project_v1/screens/login/sigup.dart';
import 'package:project_v1/screens/login/recovery_password.dart';
import 'package:project_v1/screens/profile/profile.dart';

import 'package:project_v1/widgets/buttons/custom_icon_button.dart';
import 'package:project_v1/widgets/buttons/custom_text_button.dart';
import 'package:project_v1/widgets/buttons/primary_button.dart';
import 'package:project_v1/widgets/texts/custom_text_field.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Center(
          child: Column(
            children: [
              TitleText(text: "Sign in now"),
              SizedBox(
                height: 10,
              ),
              SubtitleText(
                text: "Please sign in to continue our app",
                fontSize: 18.0,
              ),
              SizedBox(
                height: 40.0,
              ),
              CustomTextField(
                labelText: "Email",
              ),
              SizedBox(height: 25.0),
              CustomTextField(
                labelText: 'Password',
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomTextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecoveryPassword()),
                      );
                    },
                    text: "Forgot Password?"),
              ),
              SizedBox(
                height: 30.0,
              ),
              PrimaryButton(
                  text: "Sign In",
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Profile()));
                  }),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubtitleText(text: "Don't have an account?"),
                  CustomTextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signup()),
                        );
                      },
                      text: "Sign Up"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: SubtitleText(text: "Or login with"),
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomIconButton(
                      imagePath: "assets/images_icons/google_icon.png",
                      onPressed: () {}),
                  CustomIconButton(
                      imagePath: "assets/images_icons/apple_icon.png",
                      onPressed: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
