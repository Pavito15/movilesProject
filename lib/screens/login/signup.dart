import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:project_v1/widgets/buttons/custom_icon_button.dart';
import 'package:project_v1/widgets/buttons/custom_text_button.dart';
import 'package:project_v1/widgets/buttons/primary_button.dart';
import 'package:project_v1/widgets/texts/custom_text_field.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController(); // Nuevo controlador
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth
  String? _errorMessage; // Para manejar errores

  // Función para registrar un nuevo usuario con Firebase
  Future<void> _signUp() async {
    // Verifica que las contraseñas coincidan
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() {
        _errorMessage = 'Las contraseñas no coinciden.';
      });
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Verifica si el widget sigue montado antes de navegar
      if (mounted) {
        Navigator.pushReplacementNamed(
            context, '/main'); // Navega a la pantalla principal
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getErrorMessage(e.code); // Manejo de errores
        });
      }
    }
  }

  // Función para obtener mensajes de error personalizados
  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'El correo ya está registrado.';
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'weak-password':
        return 'La contraseña es demasiado débil (mínimo 6 caracteres).';
      default:
        return 'Ocurrió un error. Inténtalo de nuevo.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Libera el nuevo controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const TitleText(text: "Sign up now"),
              const SizedBox(height: 10),
              const SubtitleText(
                text: "Please fill the data and create account",
                fontSize: 18.0,
              ),
              const SizedBox(height: 40.0),
              CustomTextField(
                labelText: "Email",
                controller: _emailController, // Asigna el controlador
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25.0),
              CustomTextField(
                labelText: "Password",
                controller: _passwordController, // Asigna el controlador
                isPassword: true,
              ),
              const SizedBox(height: 25.0),
              CustomTextField(
                labelText: "Confirm Password",
                controller: _confirmPasswordController, // Asigna el controlador
                isPassword: true,
              ),
              if (_errorMessage !=
                  null) // Muestra el mensaje de error si existe
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 50.0),
              PrimaryButton(
                text: "Sign Up",
                onPressed: _signUp, // Llama a la función de registro
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SubtitleText(text: "Already have an account?"),
                  CustomTextButton(
                    text: "Sign In",
                    onPressed: () {
                      Navigator.pop(context); // Regresa a Signin
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: SubtitleText(text: "Or sign up with"),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Color.fromARGB(255, 123, 123, 123),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomIconButton(
                    imagePath: "assets/images_icons/google_icon.png",
                    onPressed: () {
                      // Aquí puedes agregar la lógica para Google Sign-Up
                    },
                  ),
                  CustomIconButton(
                    imagePath: "assets/images_icons/apple_icon.png",
                    onPressed: () {
                      // Aquí puedes agregar la lógica para Apple Sign-Up
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
