import 'package:flutter/material.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/custom_colors.dart';
import '../../Utils/enums/button_type.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? prefixImage;
  final ButtonType type;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixImage,
    this.type = ButtonType.primary,
  });

  Color _getBackgroundColor() {
    switch (type) {
      case ButtonType.primary:
        return CustomColors.primary; // Blue
      case ButtonType.secondary:
        return CustomColors.secondary; // Blue
      case ButtonType.outline:
        return CustomColors.outline; // Blue
      case ButtonType.warning:
        return CustomColors.warning; // Blue
      case ButtonType.danger:
        return CustomColors.danger; // Blue
    }
  }

  Color _getTextColor() {
    switch (type) {
      case ButtonType.warning:
        return Colors.black87;
      case ButtonType.outline:
        return Colors.black87;
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: CustomColors.darkGrey,
            width: 1, // Border thickness
          ),
          boxShadow: [
            BoxShadow(
              color: CustomColors.lightGrey,
              offset: const Offset(0, 5),
              blurRadius: 10,
              spreadRadius: 5
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (prefixImage != null) ...[
              Image.asset(
                prefixImage!,
                height: 20,
                width: 20,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
            ],
            if (prefixIcon != null) ...[
              Icon(prefixIcon, color: _getTextColor(), size: 20),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _getTextColor(),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            if (suffixIcon != null) ...[
              const SizedBox(width: 8),
              Icon(suffixIcon, color: _getTextColor(), size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
