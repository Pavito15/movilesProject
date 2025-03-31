import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa Firebase Auth
import 'package:project_v1/screens/login/signup.dart';
import 'package:project_v1/screens/login/recovery_password.dart';
import 'package:project_v1/widgets/buttons/custom_icon_button.dart';
import 'package:project_v1/widgets/buttons/custom_text_button.dart';
import 'package:project_v1/widgets/buttons/primary_button.dart';
import 'package:project_v1/widgets/texts/custom_text_field.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth
  String? _errorMessage; // Para manejar errores

  // Función para iniciar sesión con Firebase
  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Verifica si el widget sigue montado antes de navegar
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main'); // Navega a TabsScreen
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
      case 'user-not-found':
        return 'No se encontró un usuario con ese correo.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      default:
        return 'Ocurrió un error. Inténtalo de nuevo.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const TitleText(text: "Sign in now"),
              const SizedBox(height: 10),
              const SubtitleText(
                text: "Please sign in to continue our app",
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
                labelText: 'Password',
                controller: _passwordController, // Asigna el controlador
                isPassword: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CustomTextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecoveryPassword(),
                      ),
                    );
                  },
                  text: "Forgot Password?",
                ),
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
              const SizedBox(height: 30.0),
              PrimaryButton(
                text: "Sign In",
                onPressed: _signIn, // Llama a la función de inicio de sesión
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SubtitleText(text: "Don't have an account?"),
                  CustomTextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Signup(),
                        ),
                      );
                    },
                    text: "Sign Up",
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
                    child: SubtitleText(text: "Or login with"),
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
                      // Aquí puedes agregar la lógica para Google Sign-In
                    },
                  ),
                  CustomIconButton(
                    imagePath: "assets/images_icons/apple_icon.png",
                    onPressed: () {
                      // Aquí puedes agregar la lógica para Apple Sign-In
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
