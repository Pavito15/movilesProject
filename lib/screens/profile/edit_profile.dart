import 'package:flutter/material.dart';
import 'package:project_v1/screens/profile/profile.dart';
import 'package:project_v1/widgets/buttons/custom_text_button.dart';
import 'package:project_v1/widgets/custom_image_avatar.dart';
import 'package:project_v1/widgets/menus/custom_app_bar.dart';
import 'package:project_v1/widgets/texts/custom_text_field.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _firstNameController =
      TextEditingController(text: "Robert");
  final TextEditingController _lastNameController =
      TextEditingController(text: "Mancilla");
  final TextEditingController _emailController =
      TextEditingController(text: "luischavez@gmail.com");

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit profile",
        actionWidget: CustomTextButton(
          text: "Done",
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data updated.'),
                duration: Duration(seconds: 1),
              ),
            );
            Navigator.pop(context,
                MaterialPageRoute(builder: (context) => const Profile()));
          },
          textColor: Color(0xFF0D47A1),
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: CustomImageAvatar(
                  imagePath: "assets/images_icons/avatar_men.png"),
            ),
            TitleText(
              text: "Robert",
              fontWeight: FontWeight.w500,
            ),
            CustomTextButton(
              text: "Change Profile Picture",
              textColor: Color(0xFF0D47A1),
              fontWeight: FontWeight.w600,
              fontSize: 20,
              decoration: TextDecoration.none,
              onPressed: () {},
            ),
            const SizedBox(
              height: 40.0,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SubtitleText(
                text: "First Name",
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: "",
              controller: _firstNameController,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: SubtitleText(
                text: "Last Name",
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: "",
              controller: _lastNameController,
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: SubtitleText(
                text: "Email",
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            CustomTextField(
              labelText: "",
              controller: _emailController,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
