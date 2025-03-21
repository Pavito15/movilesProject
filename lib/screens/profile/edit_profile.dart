import 'package:flutter/material.dart';
import 'package:project_v1/widgets/buttons/custom_text_button.dart';
import 'package:project_v1/widgets/custom_image_avatar.dart';
import 'package:project_v1/widgets/menus/custom_app_bar.dart';
import 'package:project_v1/widgets/texts/custom_text_field.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';
import 'package:project_v1/screens/tabs.dart';

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

            // Volver a TabsScreen y mostrar tab 0 (Inicio) o el que desees
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const TabsScreen(initialIndex: 0),
              ),
              (route) => false,
            );
          },
          textColor: const Color(0xFF0D47A1),
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: CustomImageAvatar(imagePath: "assets/images_icons/avatar_men.png"),
            ),
            const TitleText(
              text: "Robert",
              fontWeight: FontWeight.w500,
            ),
            CustomTextButton(
              text: "Change Profile Picture",
              textColor: const Color(0xFF0D47A1),
              fontWeight: FontWeight.w600,
              fontSize: 20,
              decoration: TextDecoration.none,
              onPressed: () {},
            ),
            const SizedBox(height: 40.0),
            _buildInputField("First Name", _firstNameController),
            _buildInputField("Last Name", _lastNameController),
            _buildInputField("Email", _emailController),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubtitleText(
          text: label,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        const SizedBox(height: 10),
        CustomTextField(
          labelText: "",
          controller: controller,
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
