import 'package:flutter/material.dart';
import 'package:project_v1/screens/login/signin.dart';
import 'package:project_v1/screens/profile/edit_profile.dart';
import 'package:project_v1/screens/profile/profile_data.dart';

import 'package:project_v1/widgets/custom_image_avatar.dart';
import 'package:project_v1/widgets/menus/custom_app_bar.dart';
import 'package:project_v1/widgets/menus/custom_menu_profile.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

import 'package:project_v1/widgets/admin/admin_widget.dart';


class Profile extends StatelessWidget {
  const Profile({super.key});

  final List<Map<String, dynamic>> listItems = const [
    {
      'title': 'Profile',
      'leading': Icons.person_outline_rounded,
      'trailing': Icons.arrow_forward_ios_rounded,
      'destination': ProfileData()
    },
    {
      'title': 'Settings',
      'leading': Icons.settings_outlined,
      'trailing': Icons.arrow_forward_ios_rounded,
      'destination': Signin()
    },
    {
      'title': 'Log Out',
      'leading': Icons.logout_outlined,
      'trailing': Icons.arrow_forward_ios_rounded,
      'destination': Signin()
    },
    {
      'title': 'Admin Panel',
      'leading': Icons.admin_panel_settings_outlined,
      'trailing': Icons.arrow_forward_ios_rounded,
      'destination': AdminWidget()
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        onEdit: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EditProfile()));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Center(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  child: CustomImageAvatar(
                      imagePath: "assets/images_icons/avatar_men.png")),
              TitleText(
                text: "Robert",
                fontWeight: FontWeight.w500,
              ),
              SubtitleText(
                text: "luischavez@gmail.com",
                fontSize: 20,
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 20,
              ),
              CustomMenuProfile(listItems: listItems),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
