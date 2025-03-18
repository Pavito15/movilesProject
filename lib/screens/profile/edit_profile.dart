import 'package:flutter/material.dart';
import 'package:project_v1/widgets/menus/custom_app_bar.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit profile"),
      body: Center(
        child: Text(
          "Edit",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
