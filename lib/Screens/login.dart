import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytravaly_flutter_assesment/Constants/prefs.dart';
import 'package:mytravaly_flutter_assesment/Constants/routes.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/custom_button.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/page_view.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/text_view.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/custom_colors.dart';
import 'package:mytravaly_flutter_assesment/Utils/enums/button_type.dart';
import 'package:mytravaly_flutter_assesment/Utils/shared_preferences.dart';

import '../CustomUI/curve_container.dart';
import '../Utils/enums/text_type.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  // bool _isLoggedIn = false;
  // final String _userName = "Mohd. Ahmad";
  // final String _userEmail = "mohdahmad@gmail.com";

  void _simulateGoogleSignIn() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      SessionManager.setBoolean(Prefs.isLoggedIn, true);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(Routes.home, (Route<dynamic> route) => false);    });
  }

  void _logout() {
    SessionManager.setBoolean(Prefs.isLoggedIn, false);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return CustomPageView(child: _buildLoginUI()) ;
  }

  Widget _buildLoginUI() {
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/baner.gif'),
              ),
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              CurvedTopContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 120),
                    TextView(text: "Welcome Back", type: TextType.heading1),
                    const SizedBox(height: 12),
                    TextView(
                      text: "Sign in to continue with your Google account",
                      type: TextType.smallText,
                    ),
                    const SizedBox(height: 50),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                      text: "Sign in with Google",
                      onPressed: _simulateGoogleSignIn,
                      prefixImage: 'assets/images/google_logo.png',
                      type: ButtonType.outline,
                    ),
                    const SizedBox(height: 10),
                    TextView(
                      text: "Powered by MyTravaly",
                      type: TextType.smallText,
                    ),
                  ],
                ),
              ),

              const Positioned(
                top: -40,
                child: CircleAvatar(
                  radius: 83,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage("assets/images/MyTravaly_logo.webp"),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

// Widget _buildSuccessUI() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [CustomColors.lightOrange, CustomColors.orange],
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //       ),
  //     ),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Hero(
  //           tag: "logo",
  //           child: Image.asset("assets/images/MyTravaly_logo.webp", height: 80),
  //         ),
  //         const SizedBox(height: 40),
  //         const CircleAvatar(
  //           radius: 45,
  //           backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
  //         ),
  //         const SizedBox(height: 20),
  //         TextView(
  //           text : _userName,
  //           type: TextType.heading1,
  //
  //         ),
  //         const SizedBox(height: 4),
  //         TextView(
  //           text :_userEmail,
  //           type: TextType.smallText,
  //
  //         ),
  //         const SizedBox(height: 50),
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //           child: ElevatedButton(
  //             onPressed: _logout,
  //             style: ElevatedButton.styleFrom(
  //               backgroundColor: Colors.white,
  //               foregroundColor: Colors.redAccent,
  //               elevation: 5,
  //               minimumSize: const Size(double.infinity, 50),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(14),
  //               ),
  //             ),
  //             child: Text(
  //               "Logout",
  //               style: GoogleFonts.poppins(
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
