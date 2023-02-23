import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/config/color_pallete.dart';
// import 'package:interrupt/widgets/expire_link.dart';
import 'package:interrupt/widgets/primary_icon_button.dart';

import '../widgets/custom_text_field.dart';

class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  final expireTime = TextEditingController();
  bool shareProfile = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                "Select Time",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              PrimaryIconButton(
                buttonTitle: "Share Doc",
                buttonIcon: const FaIcon(FontAwesomeIcons.share),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter myState) {
                          return bottomSheet();
                        });
                      });
                },
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                height: 3,
                decoration: const BoxDecoration(color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Share Doc",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BottomSheet bottomSheet() {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
        return SizedBox(
          height: 350,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: defaultPadding,
                right: defaultPadding,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Choose Image',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.bold)
                              .fontFamily,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    hintText: "Enter Expiry time",
                    controller: expireTime,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Time Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Share Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                  .fontFamily,
                        ),
                      ),
                      Switch(
                        value: shareProfile,
                        activeColor: PalleteColor.primaryPurple,
                        onChanged: (bool value) {
                          if (mounted) {
                            setState(() {
                              shareProfile = value;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  PrimaryIconButton(
                    buttonTitle: "Next",
                    buttonIcon: const FaIcon(
                      FontAwesomeIcons.link,
                      size: 18,
                    ),
                    onPressed: () async {},
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
