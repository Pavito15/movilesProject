import 'package:flutter/material.dart';
import 'package:project_v1/widgets/texts/customs_texts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onEdit;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: AppBarText(text: title),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.edit_rounded,
            color: Colors.black,
          ),
          onPressed: onEdit,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
