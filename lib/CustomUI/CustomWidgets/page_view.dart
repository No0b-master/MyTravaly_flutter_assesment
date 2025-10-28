import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/text_view.dart';

import '../custom_colors.dart';

class CustomPageView extends StatelessWidget {
  final Widget child;
  const CustomPageView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,

      child: Scaffold(
        appBar: AppBar(
          elevation: 2,
          backgroundColor: CustomColors.orange,
          centerTitle: true,
          title: TextView(
            text: "MyTravaly",
            customStyle: GoogleFonts.robotoSerif(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: CustomColors.white,
            ),
          ),
        ),
        body: child,
      ),
    );
  }
}
