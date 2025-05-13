import 'dart:io';
import 'package:flutter/material.dart';

/// Widget que muestra una imagen de perfil en forma circular.
///
/// Puede mostrar tanto imágenes de assets como imágenes locales del dispositivo.
/// Si hay algún error al cargar la imagen, muestra una imagen predeterminada.
///
/// Si [isAsset] es true, carga la imagen desde los assets del proyecto.
/// Si [isAsset] es false, intenta cargar la imagen desde un archivo local.
class CustomImageAvatar extends StatelessWidget {
  /// Radio del círculo
  final double radius;

  /// Ruta de la imagen (puede ser asset o ruta de archivo local)
  final String imagePath;

  /// Color de fondo del círculo
  final Color backgroundColor;

  /// Indica si la imagen está en assets (true) o es un archivo local (false)
  final bool isAsset;

  const CustomImageAvatar({
    super.key,
    this.radius = 60.0,
    required this.imagePath,
    this.backgroundColor = Colors.white,
    this.isAsset = true,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: ClipOval(
        child: isAsset || !imagePath.startsWith('/')
            ? Image.asset(
                imagePath.isEmpty
                    ? "assets/images_icons/avatar_men.png"
                    : imagePath,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Mostrar imagen predeterminada en caso de error
                  return Image.asset(
                    "assets/images_icons/avatar_men.png",
                    width: radius * 2,
                    height: radius * 2,
                    fit: BoxFit.cover,
                  );
                },
              )
            : Image.file(
                File(imagePath),
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Mostrar imagen predeterminada en caso de error
                  return Image.asset(
                    "assets/images_icons/avatar_men.png",
                    width: radius * 2,
                    height: radius * 2,
                    fit: BoxFit.cover,
                  );
                },
              ),
      ),
    );
  }
}
