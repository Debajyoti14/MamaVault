import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/color_pallete.dart';
import 'package:interrupt/widgets/primary_icon_button.dart';
// import 'package:interrupt/config/UI_constraints.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 180,
          ),
          Transform.scale(
            scale: 0.8,
            child: SvgPicture.asset('assets/logoSvg.svg'),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Sign Up",
            style: TextStyle(
              fontSize: 32,
              fontFamily: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 32,
              ).fontFamily,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Hello! Welcome Back",
            style: TextStyle(
              color: const Color.fromARGB(174, 14, 14, 23),
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
          const SizedBox(
            height: 120,
          ),
          const PrimaryIconButton(
            buttonTitle: "Sign In with Google",
            buttonIcon: FaIcon(FontAwesomeIcons.google),
          ),
          const SizedBox(
            height: 50,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(118, 14, 14, 23),
                  ),
                  children: <TextSpan>[
                    TextSpan(text: "By Clicking Sign up you agree to the "),
                    TextSpan(
                      text: "Terms of services ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: PalleteColor.primaryPurple),
                    ),
                    TextSpan(text: "and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: PalleteColor.primaryPurple),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
