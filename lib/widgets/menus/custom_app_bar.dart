import 'package:flutter/material.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onEdit;
  final Widget? actionWidget; // nuevo parámetro para acción personalizada

  const CustomAppBar({
    super.key,
    required this.title,
    this.onEdit,
    this.actionWidget,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: AppBarText(text: title),
      centerTitle: true,
      actions: [
        // Si se pasa un widget de acción, se utiliza; de lo contrario, se muestra el botón de edición
        actionWidget ??
            IconButton(
              icon: const Icon(
                Icons.edit_rounded,
                color: Color(0xFF0D47A1),
              ),
              onPressed: onEdit,
            ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 