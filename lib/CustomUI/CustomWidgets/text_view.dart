import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytravaly_flutter_assesment/CustomUI/custom_colors.dart';

import '../../Utils/enums/text_type.dart';

class TextView extends StatelessWidget {
  final String text;
  final TextType? type;
  final TextStyle? customStyle;

  const TextView({
    super.key,
    required this.text,
    this.type,
    this.customStyle,
  });

  TextStyle _getTextStyle() {
    switch (type ?? TextType.mediumText) {
      case TextType.heading1:
        return GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: CustomColors.black,
        );
      case TextType.heading2:
        return GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: CustomColors.black,
        );
      case TextType.heading3:
        return GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: CustomColors.black,
        );
      case TextType.mediumText:
        return GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: CustomColors.darkGrey,
        );
      case TextType.smallText:
        return GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: CustomColors.darkGrey,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: customStyle ?? _getTextStyle(),
    );
  }
}
