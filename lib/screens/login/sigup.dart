import 'package:flutter/material.dart';
import 'package:project_v1/screens/login/signin.dart';

import 'package:project_v1/widgets/buttons/custom_icon_button.dart';
import 'package:project_v1/widgets/buttons/custom_text_button.dart';
import 'package:project_v1/widgets/buttons/primary_button.dart';
import 'package:project_v1/widgets/texts/custom_text_field.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: Center(
          child: Column(
            children: [
              TitleText(text: "Sign up now"),
              SizedBox(
                height: 10,
              ),
              SubtitleText(
                text: "Please fill the data and create account",
                fontSize: 18.0,
              ),
              SizedBox(
                height: 40.0,
              ),
              CustomTextField(
                labelText: "Name",
              ),
              SizedBox(height: 25.0),
              CustomTextField(
                labelText: "Email",
              ),
              SizedBox(height: 25.0),
              CustomTextField(
                labelText: "Password",
                isPassword: true,
              ),
              SizedBox(
                height: 50.0,
              ),
              PrimaryButton(text: "Sign Up", onPressed: () {}),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubtitleText(text: "Already have an account?"),
                  CustomTextButton(
                      text: "Sign In",
                      onPressed: () {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()),
                        );
                      }),
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
                    child: SubtitleText(text: "Or sign up with"),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
