import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project_v1/provider/user_provider.dart';
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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Actualizaremos los controladores después del primer render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllers();
    });
  }

  void _updateControllers() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      setState(() {
        _firstNameController.text = user.name;
        _lastNameController.text = user.surname;
        _emailController.text = user.email;
        _addressController.text = user.address;
        _phoneController.text = user.phone;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile Info",
        onEdit: () async {
          // Espera el resultado de la navegación y actualiza los controladores si es necesario
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const EditProfile()));

          // Si retornamos true, actualizamos los controladores
          if (result == true) {
            _updateControllers();
          }
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
                  imagePath: (user != null && user.pictureProfile.isNotEmpty)
                      ? user.pictureProfile
                      : "assets/images_icons/avatar_men.png",
                  isAsset: (user == null || user.pictureProfile.isEmpty),
                ),
              ),
              TitleText(
                text: (user?.name == null || user?.name == "")
                    ? "No Name"
                    : user!.name,
                fontWeight: FontWeight.w500,
              ),
              SubtitleText(
                text: user?.email ?? "correo@ejemplo.com",
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
              _firstNameController.text.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 237, 238),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 12.0),
                      width: double.infinity,
                      child: const Text(
                        "No name",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : CustomTextField(
                      labelText: "",
                      controller: _firstNameController,
                      readOnly: true,
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
              _lastNameController.text.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 237, 238),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 12.0),
                      width: double.infinity,
                      child: const Text(
                        "No last name",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : CustomTextField(
                      labelText: "",
                      controller: _lastNameController,
                      readOnly: true,
                    ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: SubtitleText(
                  text: "Address",
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _addressController.text.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 237, 238),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 12.0),
                      width: double.infinity,
                      child: const Text(
                        "No address",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : CustomTextField(
                      labelText: "",
                      controller: _addressController,
                      readOnly: true,
                    ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: SubtitleText(
                  text: "Phone",
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              _phoneController.text.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 237, 238),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 12.0),
                      width: double.infinity,
                      child: const Text(
                        "No phone",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : CustomTextField(
                      labelText: "",
                      controller: _phoneController,
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
              _emailController.text.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 237, 238),
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 12.0),
                      width: double.infinity,
                      child: const Text(
                        "No email",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : CustomTextField(
                      labelText: "",
                      controller: _emailController,
                      readOnly: true,
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
