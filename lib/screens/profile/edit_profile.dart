import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:project_v1/screens/login/signin.dart'; // Para redirigir a Signin
import 'package:provider/provider.dart';
import 'package:project_v1/provider/user_provider.dart';
import 'package:project_v1/widgets/buttons/custom_text_button.dart';
import 'package:project_v1/widgets/buttons/primary_button.dart';
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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Actualizaremos los controladores después del primer render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  void _loadUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;

    if (user != null) {
      setState(() {
        _firstNameController.text = user.name;
        _lastNameController.text = user.surname;
        _emailController.text = user.email;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Función para eliminar el perfil
  Future<void> _deleteProfile() async {
    // Mostrar diálogo de confirmación
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text(
            '¿Estás seguro de que quieres eliminar tu perfil? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Cancelar
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Confirmar
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return; // Si no confirma, no hace nada

    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.delete(); // Elimina la cuenta del usuario
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil eliminado exitosamente.')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Signin()),
            (Route<dynamic> route) =>
                false, // Elimina todas las rutas anteriores
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No hay usuario autenticado.')),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        String errorMessage;
        if (e.code == 'requires-recent-login') {
          errorMessage =
              'Por seguridad, inicia sesión nuevamente para eliminar tu cuenta.';
          // Aquí podrías redirigir a una pantalla de reautenticación
        } else {
          errorMessage = 'Error al eliminar el perfil: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  // Función para actualizar el perfil
  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final currentUser = userProvider.user;

      if (currentUser != null) {
        // Crear un objeto UserModel actualizado con los nuevos datos
        final updatedUser = currentUser.copyWith(
          name: _firstNameController.text.trim(),
          surname: _lastNameController.text.trim(),
          // No actualizamos el email aquí porque requeriría reautenticación
        );

        // Actualizar los datos en Firestore
        await userProvider.updateUser(updatedUser);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Perfil actualizado exitosamente')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Edit profile",
        actionWidget: CustomTextButton(
          text: "Done",
          onPressed: () {
            _updateProfile();
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
              child: CustomImageAvatar(
                  imagePath: "assets/images_icons/avatar_men.png"),
            ),
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final user = userProvider.user;
                return TitleText(
                  text: (user?.name == null || user?.name == "")
                      ? "Update Info"
                      : user!.name,
                  fontWeight: FontWeight.w500,
                );
              },
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
            const SizedBox(height: 40.0),
            PrimaryButton(
              text: "Delete Profile",
              onPressed: _deleteProfile, // Llama a la función de eliminación
              backgroundColor: Colors.red,
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    // Determinar si el campo debe ser de solo lectura basado en si es email
    final bool readOnly = label == "Email";

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
          readOnly: readOnly,
          onChanged: (value) => setState(() {}),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
