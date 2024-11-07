import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../home_screen.dart';
import '../web_screen/web_home-screen.dart';

class CombinedHomeLayout extends StatelessWidget {
  const CombinedHomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => HomeScreen(),
      tablet: (BuildContext context) => WebHomeScreen(),
    );
  }
}

