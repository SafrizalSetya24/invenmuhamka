import 'package:flutter/material.dart';

class NavHelper {
  /// Navigates to a new page without any animation or transition delay,
  /// preventing the sidebar and top header from flickering or jumping.
  static void navigateTo(BuildContext context, Widget targetPage) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => targetPage,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
