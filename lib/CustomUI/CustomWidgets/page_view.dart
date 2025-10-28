import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytravaly_flutter_assesment/Constants/prefs.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/text_view.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/CustomWidgets/toggle_theme_button.dart';
import 'package:mytravaly_flutter_assesment/Utils/helpers/dialog.dart';
import 'package:mytravaly_flutter_assesment/Utils/shared_preferences.dart';
import '../../Constants/routes.dart';
import '../../Utils/enums/dialog_type.dart';
import '../custom_colors.dart';

class CustomPageView extends StatelessWidget {
  final Widget child;
  const CustomPageView({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,

      child: Scaffold(
        floatingActionButton: ThemeToggle(),
        appBar: AppBar(
          actions: SessionManager.getBoolean(Prefs.isLoggedIn) == true
              ? [
                  Padding(
                    padding: const EdgeInsets.only(right: 18.0),
                    child: GestureDetector(
                      onTap: () {
                        showCustomDialog(
                          context: context,
                          dialogType: DialogType.confirmation,
                          message: "Are you sure you wanted to logout",
                          onYes: () {
                            SessionManager.setBoolean(Prefs.isLoggedIn, false);
                            _logout(context);
                          },
                        );
                      },
                      child: Icon(Icons.logout),
                    ),
                  ),
                ]
              : [Container()],
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

  void _logout(BuildContext context) {
    SessionManager.setBoolean(Prefs.isLoggedIn, false);
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(Routes.login, (Route<dynamic> route) => false);
  }
}
