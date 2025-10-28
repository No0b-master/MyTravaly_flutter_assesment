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
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixImage,
    this.type = ButtonType.primary,
    this.width,
  });

  /// Returns color according to the theme and button type
  Color _getBackgroundColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case ButtonType.primary:
        return theme.colorScheme.primary;
      case ButtonType.secondary:
        return theme.colorScheme.secondary;
      case ButtonType.warning:
        return CustomColors.warning;
      case ButtonType.outline:
        return Colors.transparent;
      case ButtonType.danger:
        return CustomColors.warning;
      default:
        return theme.colorScheme.primary;
    }
  }

  Color _getTextColor(BuildContext context) {
    final theme = Theme.of(context);
    switch (type) {
      case ButtonType.warning:
        return theme.brightness == Brightness.dark
            ? CustomColors.black
            : Colors.black87;
      case ButtonType.outline:
        return theme.brightness == Brightness.dark
            ? CustomColors.white
            : Colors.black87;
      default:
        return CustomColors.white;
    }
  }

  Border? _getBorder(BuildContext context) {
    final theme = Theme.of(context);
    if (type == ButtonType.outline) {
      return Border.all(
        color: theme.colorScheme.primary,
        width: 1.5,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _getBackgroundColor(context),
          borderRadius: BorderRadius.circular(12),
          border: _getBorder(context),
          boxShadow: [
            if (theme.brightness == Brightness.light)
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                offset: const Offset(0, 4),
                blurRadius: 8,
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
              Icon(prefixIcon, color: _getTextColor(context), size: 20),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _getTextColor(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            if (suffixIcon != null) ...[
              const SizedBox(width: 8),
              Icon(suffixIcon, color: _getTextColor(context), size: 20),
            ],
          ],
        ),
      ),
    );
  }
}
