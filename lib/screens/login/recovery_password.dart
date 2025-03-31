import 'package:flutter/material.dart';
import 'package:project_v1/screens/login/otp_verification.dart';

import 'package:project_v1/widgets/buttons/primary_button.dart';
import 'package:project_v1/widgets/texts/custom_text_field.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';


class RecoveryPassword extends StatelessWidget {
  const RecoveryPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Center(
          child: Column(
            children: [
              TitleText(text: "Forgot password"),
              SizedBox(
                height: 10,
              ),
              SubtitleText(
                text: "Enter your email account to reset your\npassword",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 40.0,
              ),
              CustomTextField(
                labelText: "Email",
              ),
              SizedBox(height: 50.0),
              PrimaryButton(
                  text: "Recovery Password",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OtpVerification()),
                    );
                  }),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
