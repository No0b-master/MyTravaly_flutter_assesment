import 'package:flutter/material.dart';

class CurvedTopContainer extends StatelessWidget {
  final Widget child;

  const CurvedTopContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: TopCurveClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.1,
        color: Colors.white,
        width: double.infinity,
        child: child,
      ),
    );
  }
}

class TopCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from bottom-left
    path.lineTo(0, size.height);

    // Line to bottom-right
    path.lineTo(size.width, size.height);

    // Line to top-right curve start
    path.lineTo(size.width, 80);

    // Create a smooth curve (adjust the control points to modify curve depth)
    path.quadraticBezierTo(
      size.width / 2,
      0,  // control point (how deep the curve goes)
      0,
      80, // endpoint
    );

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
