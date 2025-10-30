import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytravaly_flutter_assesment/Constants/prefs.dart';
import 'package:mytravaly_flutter_assesment/Constants/routes.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/custom_button.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/page_view.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/custom_colors.dart';
import 'package:mytravaly_flutter_assesment/Utils/enums/button_type.dart';
import 'package:mytravaly_flutter_assesment/Utils/helpers/snackbar_message.dart';
import 'package:mytravaly_flutter_assesment/Utils/shared_preferences.dart';
import '../CustomUI/curve_container.dart';
import '../services/register_device_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;

  Future<void> _simulateGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      ///Regstring device
      final registered = await RegisterDeviceService.registerDevice();

      if (registered) {
        await Future.delayed(const Duration(seconds: 1));
        await SessionManager.setBoolean(Prefs.isLoggedIn, true);

        if (mounted) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            Routes.home,
                (Route<dynamic> route) => false,
          );
        }
      } else {
        showSnackBarMessage(context: context, message: "Device registration failed. Please try again.") ;

      }
    } catch (e) {
      print("SignIn Error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return CustomPageView(
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(

              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/baner.gif'),
                ),
              ),
            ),

            /// Foreground Curved Container
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                CurvedTopContainer(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? CustomColors.darkBackground.withValues(alpha:0.9)
                          : CustomColors.lightBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:0.15),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 120),
                        Text(
                          "Welcome Back",
                          style: GoogleFonts.poppins(
                            color: isDark
                                ? CustomColors.secondary
                                : CustomColors.primary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Sign in to continue with your Google account",
                          style: GoogleFonts.poppins(
                            color: isDark
                                ? CustomColors.lightText.withValues(alpha:0.7)
                                : CustomColors.darkText.withValues(alpha:0.7),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 50),

                        /// Sign-in button
                        _isLoading
                            ? const CircularProgressIndicator(
                          color: CustomColors.accent,
                        )
                            : CustomButton(
                          text: "Sign in with Google",
                          onPressed: _simulateGoogleSignIn,
                          prefixImage: 'assets/images/google_logo.png',
                          type: ButtonType.outline,
                          width: 260,
                        ),

                        const SizedBox(height: 20),
                        Text(
                          "Powered by MyTravaly",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isDark
                                ? CustomColors.lightText.withValues(alpha:0.6)
                                : CustomColors.darkText.withValues(alpha:0.6),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                /// Logo circle
                const Positioned(
                  top: -40,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: CustomColors.white,
                    child: CircleAvatar(
                      radius: 76,
                      backgroundImage:
                      AssetImage("assets/images/MyTravaly_logo.webp"),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





