import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:project_v1/screens/login/signin.dart';
import 'package:project_v1/screens/profile/edit_profile.dart';
import 'package:project_v1/screens/profile/profile_data.dart';
import 'package:project_v1/widgets/custom_image_avatar.dart';
import 'package:project_v1/widgets/menus/custom_app_bar.dart';
import 'package:project_v1/widgets/menus/custom_menu_profile.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';
import 'package:project_v1/widgets/admin/admin_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final List<Map<String, dynamic>> listItems = const [
    {
      'title': 'Profile',
      'leading': Icons.person_outline_rounded,
      'trailing': Icons.arrow_forward_ios_rounded,
      'destination': ProfileData(),
    },
    {
      'title': 'Settings',
      'leading': Icons.settings_outlined,
      'trailing': Icons.arrow_forward_ios_rounded,
      'destination': null,
    },
    {
      'title': 'Admin Panel',
      'leading': Icons.admin_panel_settings_outlined,
      'trailing': Icons.arrow_forward_ios_rounded,
      'destination': AdminWidget(),
    },
    {
      'title': 'Log Out',
      'leading': Icons.logout_outlined,
      'trailing': Icons.arrow_forward_ios_rounded,
      'destination': null,
    },
  ];

  // llog out function
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Signin()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        onEdit: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProfile()),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: CustomImageAvatar(
                  imagePath: "assets/images_icons/avatar_men.png",
                ),
              ),
              const TitleText(
                text: "Robert",
                fontWeight: FontWeight.w500,
              ),
              const SubtitleText(
                text: "luischavez@gmail.com",
                fontSize: 20,
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 20),
              CustomMenuProfile(
                listItems: listItems.map((item) {
                  if (item['title'] == 'Log Out') {
                    return {
                      'title': item['title'],
                      'leading': item['leading'],
                      'trailing': item['trailing'],
                      'onTap': () =>
                          _signOut(), // Llamamos a la función de cerrar sesión
                    };
                  }
                  return {
                    'title': item['title'],
                    'leading': item['leading'],
                    'trailing': item['trailing'],
                    'destination': item['destination'],
                  };
                }).toList(),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
