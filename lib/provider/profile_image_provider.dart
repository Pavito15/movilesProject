// import 'dart:io';
// import 'package:flutter/widgets.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ProfileImageProvider extends ChangeNotifier {
//   File? _imageFile;
//   File? get imageFile => _imageFile;

//   ProfileImageProvider() {
//     _loadFromPrefs();
//   }

//   Future<void> _loadFromPrefs() async {
//     final prefs = await SharedPreferences.getInstance();
//     // final path = prefs.getString('profile_image_path')
//     if (path != null) {
//       final file = File(path);
//       if (file.existsSync()) {
//         _imageFile = file;
//         notifyListeners();
//       } else {
//         // archivo borrado/inválido
//         prefs.remove('profile_image_path');
//       }
//     }
//   }

//   Future<void> setImage(File pickedFile) async {
//     // 1) copia a documentos
//     final appDir = await getApplicationDocumentsDirectory();
//     final saved = await pickedFile.copy('${appDir.path}/profile.png');

//     // 2) guarda la ruta en prefs
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('profile_image_path', saved.path);

//     // 3) actualiza provider
//     _imageFile = saved;
//     notifyListeners();
//   }

//   Future<void> clearImage() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('profile_image_path');
//     _imageFile = null;
//     notifyListeners();
//   }
// }
