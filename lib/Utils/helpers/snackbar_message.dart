import 'package:flutter/material.dart';

import '../enums/snackbar_type.dart';


void showSnackBarMessage({
  required BuildContext context,
  required String message,
  SnackBarType type = SnackBarType.normal,
}) {
  // Define colors and icons for each type
  Color bgColor;
  IconData iconData;

  switch (type) {
    case SnackBarType.success:
      bgColor = Colors.green.shade600;
      iconData = Icons.check_circle_rounded;
      break;
    case SnackBarType.error:
      bgColor = Colors.red.shade600;
      iconData = Icons.error_rounded;
      break;
    case SnackBarType.normal:
    bgColor = Colors.grey.shade800;
      iconData = Icons.info_outline_rounded;
      break;
  }

  // Create the snackbar content with animation
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    elevation: 0,
    duration: const Duration(seconds: 3),
    content: TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 10), // subtle slide from bottom
          child: child,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: bgColor.withAlpha(2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(iconData, color: Colors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  // Show the snackbar
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
