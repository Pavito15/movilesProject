import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:project_v1/provider/user_provider.dart';
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
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _errorMessage;

  //future para registrar usuario en firestore database

  Future<void> saveUserToFirestore(User user,
      {String provider = 'email'}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    final token = await FirebaseMessaging.instance.getToken();

    await users.doc(user.uid).set({
      'email': user.email ?? '',
      'isActive': true,
      'name': user.displayName?.split(' ').first ?? '',
      'surname': user.displayName?.split(' ').skip(1).join(' ') ?? '',
      'phone': user.phoneNumber ?? '',
      'pictureProfile': user.photoURL ?? '',
      'provider': provider,
      'role': 'user',
      'tokenDevice': token,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> _loadUserData(User user) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.getUserData(user.uid);
  }

  // Función para registrar con email y contraseña
  Future<void> _signUp() async {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() {
        _errorMessage = 'Las contraseñas no coinciden.';
      });
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        // Guardar los datos en Firestore
        await saveUserToFirestore(user);
        // Llamar a la función para cargar los datos del usuario
        await _loadUserData(user);
        // Navegar a la pantalla principal
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/main');
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = _getErrorMessage(e.code);
        });
      }
    }
  }

  // Función para registrarse con Google
  Future<void> _signUpWithGoogle() async {
    try {
      // Cierra la sesión anterior de Google para forzar el selector de cuentas
      await _googleSignIn.signOut();

      // Inicia el flujo de autenticación de Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        setState(() {
          _errorMessage = 'Registro cancelado';
        });
        return;
      }

      // Obtiene las credenciales de autenticación
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Crea una credencial para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Intenta registrar/iniciar sesión con la credencial
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (userCredential.additionalUserInfo?.isNewUser == true &&
          user != null) {
        await saveUserToFirestore(user, provider: 'google');
      }

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
          _errorMessage = 'Error al registrar con Google: $e';
        });
      }
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'El correo ya está registrado. Usa Sign In.';
      case 'invalid-email':
        return 'El correo electrónico no es válido.';
      case 'weak-password':
        return 'La contraseña es demasiado débil (mínimo 6 caracteres).';
      case 'account-exists-with-different-credential':
        return 'La cuenta ya existe con un método de inicio diferente. Usa Sign In.';
      default:
        return 'Ocurrió un error. Inténtalo de nuevo.';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25.0),
              CustomTextField(
                labelText: "Password",
                controller: _passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 25.0),
              CustomTextField(
                labelText: "Confirm Password",
                controller: _confirmPasswordController,
                isPassword: true,
              ),
              if (_errorMessage != null)
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
                onPressed: _signUp,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SubtitleText(text: "Already have an account?"),
                  CustomTextButton(
                    text: "Sign In",
                    onPressed: () {
                      Navigator.pop(context);
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
                    onPressed: _signUpWithGoogle,
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
