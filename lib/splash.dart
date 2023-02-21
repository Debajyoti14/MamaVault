import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interrupt/config/color_pallete.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: Transform.scale(
            scale: 7, child: SvgPicture.asset('assets/logoSvg.svg')),
      ),
      const SizedBox(height: 30),
      const Text(
        'MamaVault',
        style: TextStyle(color: PalleteColor.primaryPurple, fontSize: 26),
      )
    ]);
  }
}
