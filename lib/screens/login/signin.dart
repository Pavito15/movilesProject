import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _errorMessage;

  // Sign in con email y contraseña
  Future<void> _signIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getErrorMessage(e.code);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error inesperado: $e';
        });
      }
    }
  }

  // Sign in con Google
  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _errorMessage = 'Inicio de sesión cancelado';
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main');
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getErrorMessage(e.code);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Error al iniciar sesión con Google: $e';
        });
      }
    }
  }

  // Función para obtener mensajes de error personalizados
  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'account-exists-with-different-credential':
        return 'La cuenta ya existe con un método de inicio diferente.';
      case 'invalid-credential':
        return 'Las credenciales no son válidas. Revisa tu correo o contraseña.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Intenta de nuevo más tarde.';
      default:
        return 'Ocurrió un error: $code. Inténtalo de nuevo.';
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25.0),
              CustomTextField(
                labelText: 'Password',
                controller: _passwordController,
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
              if (_errorMessage != null)
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
                onPressed: _signIn,
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
                    onPressed: _signInWithGoogle,
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
