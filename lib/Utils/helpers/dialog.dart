import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/custom_button.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/custom_colors.dart';
import '../../Constants/prefs.dart';
import '../../Constants/routes.dart';
import '../enums/button_type.dart';
import '../enums/dialog_type.dart';
import '../shared_preferences.dart';

void showCustomDialog({
  required BuildContext context,
  required DialogType dialogType,
  String? title,
  String? message,
  VoidCallback? onYes,
  VoidCallback? onNo,
  VoidCallback? onOk,
  String yesText = "Yes",
  String noText = "No",
  String okText = "Ok",
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  String dialogTitle = title ??
      (dialogType == DialogType.confirmation ? "Confirmation" : "Information");

  String dialogMessage = message ??
      (dialogType == DialogType.confirmation
          ? "Are you sure you want to proceed?"
          : "");

  // Define animations based on dialog type
  String animationPath = dialogType == DialogType.confirmation
      ? 'assets/animations/warning.json'
      : 'assets/animations/info.json';

  showGeneralDialog(
    context: context,
    barrierLabel: "CustomDialog",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (context, anim1, anim2) {
      return const SizedBox.shrink();
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return Transform.scale(
        scale: Curves.easeOutBack.transform(anim1.value),
        child: Opacity(
          opacity: anim1.value,
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 10,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(40),
                bottom: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(40),
                bottom: Radius.circular(20),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                        CustomColors.darkBackground.withOpacity(0.9),
                        CustomColors.primary.withOpacity(0.8),
                      ]
                          : [
                        CustomColors.lightBackground.withOpacity(0.95),
                        CustomColors.secondary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: isDark
                          ? CustomColors.accent.withOpacity(0.4)
                          : CustomColors.primary.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.4)
                            : CustomColors.primary.withOpacity(0.2),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(40),
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Animation
                        Lottie.asset(
                          animationPath,
                          height: dialogType == DialogType.info ? 120 : 100,
                          frameRate: FrameRate.max,
                          repeat: true,
                        ),
                        const SizedBox(height: 10),

                        /// Title
                        Text(
                          dialogTitle,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? CustomColors.secondary
                                : CustomColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// Message
                        Text(
                          dialogMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark
                                ? CustomColors.lightText.withOpacity(0.85)
                                : CustomColors.darkText.withOpacity(0.85),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// Buttons
                        if (dialogType == DialogType.confirmation)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildDialogButton(
                                type: ButtonType.primary,
                                text: yesText,
                                onPressed: onYes!,
                              ),
                              _buildDialogButton(
                                type: ButtonType.danger,
                                text: noText,
                                onPressed: onNo ?? () => Navigator.pop(context),
                              ),
                            ],
                          )
                        else if (dialogType == DialogType.info)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildDialogButton(
                                type: ButtonType.primary,
                                text: okText,
                                onPressed:
                                onOk ?? () => Navigator.pop(context),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget _buildDialogButton({
  required String text,
  required VoidCallback onPressed,
  required ButtonType type,
}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: CustomButton(
        text: text,
        type: type,
        onPressed: onPressed,
      ),
    ),
  );
}
