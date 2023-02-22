import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingComponent extends StatelessWidget {
  final String imagePath;
  final String settingTitle;
  final void Function()? onPressed;
  const SettingComponent(
      {super.key,
      required this.imagePath,
      required this.settingTitle,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromARGB(255, 224, 223, 223),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              scale: 0.8,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              settingTitle,
              style: TextStyle(
                fontSize: 21,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
              ),
            )
          ],
        ),
      ),
    );
  }
}
