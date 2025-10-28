import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/custom_button.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/text_view.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/custom_colors.dart';
import 'package:mytravaly_flutter_assesment/Utils/enums/button_type.dart';

import '../Utils/enums/text_type.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  final String _userName = "Mohd. Ahmad";
  final String _userEmail = "mohdahmad@gmail.com";

  void _simulateGoogleSignIn() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _isLoggedIn = true;
    });
  }

  void _logout() {
    setState(() => _isLoggedIn = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: _isLoggedIn ? _buildSuccessUI() : _buildLoginUI(),
        ),
      ),
    );
  }

  Widget _buildLoginUI() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            // App logo
            Hero(
              tag: "logo",
              child: Image.asset(
                "assets/images/MyTravaly_logo.webp",
                height: 100,
              ),
            ),
            const SizedBox(height: 30),
            TextView(text: "Welcome Back", type: TextType.heading1),
            const SizedBox(height: 12),
            TextView(text: "Sign in to continue with your Google account", type: TextType.smallText),


            const SizedBox(height: 50),

            _isLoading
                ? const CircularProgressIndicator() :

            CustomButton(text: "Sign in with Google", onPressed: _simulateGoogleSignIn ,
            prefixImage : 'assets/images/google_logo.png',
              type: ButtonType.outline,
            ),

            const SizedBox(height: 80),
            TextView(
             text:  "Powered by MyTravaly",
              type: TextType.smallText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessUI() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [CustomColors.lightOrange, CustomColors.orange],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: "logo",
            child: Image.asset("assets/images/MyTravaly_logo.webp", height: 80),
          ),
          const SizedBox(height: 40),
          const CircleAvatar(
            radius: 45,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=3'),
          ),
          const SizedBox(height: 20),
          TextView(
            text : _userName,
            type: TextType.heading1,

          ),
          const SizedBox(height: 4),
          TextView(
            text :_userEmail,
            type: TextType.smallText,

          ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.redAccent,
                elevation: 5,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                "Logout",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
