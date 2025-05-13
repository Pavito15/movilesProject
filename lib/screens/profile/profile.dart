import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:project_v1/provider/user_provider.dart';
import 'package:project_v1/provider/theme_provider.dart'; // Importamos el ThemeProvider
import 'package:project_v1/services/auth_service.dart'; // Importamos el AuthService
import 'package:project_v1/screens/login/signin.dart';
import 'package:project_v1/screens/profile/edit_profile.dart';
import 'package:project_v1/screens/profile/profile_data.dart';
import 'package:project_v1/screens/profile/my_orders_screen.dart'; // Importamos MyOrdersScreen
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

  // Verifica si un archivo de imagen existe y es accesible
  bool _isValidImagePath(String path) {
    if (path.isEmpty) return false;
    try {
      final file = File(path);
      return file.existsSync();
    } catch (e) {
      return false;
    }
  }

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
  }

  Future<void> _signOut() async {
    // Usar el AuthService para cerrar sesión
    await Provider.of<AuthService>(context, listen: false).signOut();

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
                  themeProvider.toggleTheme(ThemeMode.light);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Oscuro'),
                value: ThemeMode.dark,
                groupValue: themeProvider.themeMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(ThemeMode.dark);
                  Navigator.of(context).pop();
                },
              )
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

    // Construye la lista de items dinámicamente según el rol
    final List<Map<String, dynamic>> listItems = [
      {
        'title': 'Profile',
        'leading': Icons.person_outline_rounded,
        'trailing': Icons.arrow_forward_ios_rounded,
        'destination': const ProfileData(),
      },
      {
        'title': 'My Orders',
        'leading': Icons.inventory_2_outlined,
        'trailing': Icons.arrow_forward_ios_rounded,
        'destination': const MyOrdersScreen(),
      },
      {
        'title': 'Theme Mode',
        'leading': Icons.dark_mode_outlined,
        'trailing': null,
        'onTap': () => _showThemeDialog(),
      },
      if (user != null && user.role == 'admin') // Solo admins ven este item
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
    ];

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
              const SnackBar(
                content: Text(
                    'No se puede editar el perfil. Usuario no disponible.'),
              ),
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
                  imagePath: (user != null &&
                          user.pictureProfile.isNotEmpty &&
                          _isValidImagePath(user.pictureProfile))
                      ? user.pictureProfile
                      : "assets/images_icons/avatar_men.png",
                  isAsset: (user == null ||
                      user.pictureProfile.isEmpty ||
                      !_isValidImagePath(user.pictureProfile)),
                ),
              ),
              TitleText(
                text:
                    (user == null || user.name.isEmpty) ? "No Name" : user.name,
                fontWeight: FontWeight.w500,
              ),
              SubtitleText(
                text: (user == null || user.email.isEmpty)
                    ? "correo@ejemplo.com"
                    : user.email,
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