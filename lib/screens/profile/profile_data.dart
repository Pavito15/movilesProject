import 'package:flutter/material.dart';
import 'package:project_v1/screens/profile/edit_profile.dart';
import 'package:project_v1/widgets/custom_image_avatar.dart';
import 'package:project_v1/widgets/menus/custom_app_bar.dart';
import 'package:project_v1/widgets/texts/custom_text_field.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

class ProfileData extends StatefulWidget {
  const ProfileData({super.key});

  @override
  State<ProfileData> createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
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
        title: "Profile Info",
        onEdit: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EditProfile()));
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: CustomImageAvatar(
                  imagePath: "assets/images_icons/avatar_men.png",
                ),
              ),
              TitleText(
                text: "Robert",
                fontWeight: FontWeight.w500,
              ),
              SubtitleText(
                text: "luischavez@gmail.com",
                fontSize: 20,
              ),
              const SizedBox(height: 40.0),
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
                  readOnly: true),
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
                readOnly: true,
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
                readOnly: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
