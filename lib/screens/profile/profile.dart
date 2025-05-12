import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:project_v1/provider/user_provider.dart';
import 'package:project_v1/provider/theme_provider.dart'; // Importamos el ThemeProvider
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
  final List<Map<String, dynamic>> listItems = [];

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;

    // Solo hacer la consulta a Firestore si los datos del usuario no están ya en el provider
    if (user != null && userProvider.user == null) {
      await userProvider.getUserData(user.uid);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Configuramos los elementos del menú
    listItems.addAll([
      {
        'title': 'Profile',
        'leading': Icons.person_outline_rounded,
        'trailing': Icons.arrow_forward_ios_rounded,
        'destination': const ProfileData(),
      },
      {
        'title': 'Theme Mode',
        'leading': Icons.dark_mode_outlined,
        'trailing': null,
        'onTap': () => _showThemeDialog(),
      },
      {
        'title': 'Admin Panel',
        'leading': Icons.admin_panel_settings_outlined,
        'trailing': Icons.arrow_forward_ios_rounded,
        'destination': const AdminWidget(),
      },
      {
        'title': 'Log Out',
        'leading': Icons.logout_outlined,
        'trailing': Icons.arrow_forward_ios_rounded,
        'onTap': () => _signOut(),
      },
    ]);
  }

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

  void _showThemeDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Claro'),
                value: ThemeMode.light,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(false);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Oscuro'),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(true);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        onEdit: () {
          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfile()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No se puede editar el perfil. Usuario no disponible.')),
            );
          }
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
                  imagePath: "assets/images_icons/avatar_men.png",
                ),
              ),
              TitleText(
                text: user?.name ?? "No Name", // Muestra "No Name" si el usuario es null
                fontWeight: FontWeight.w500,
              ),
              SubtitleText(
                text: user?.email ?? "correo@ejemplo.com", // Muestra un correo predeterminado si es null
                fontSize: 20,
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 20),
              CustomMenuProfile(
                listItems: listItems,
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}