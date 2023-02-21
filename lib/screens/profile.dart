import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/config/color_pallete.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PalleteColor.bodyTextColorLight,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                        .fontFamily,
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 220, 218, 218),
                    ),
                    elevation: 0,
                    backgroundColor: PalleteColor.bodyTextColorLight,
                  ),
                  onPressed: () {},
                  icon: const FaIcon(
                    FontAwesomeIcons.pen,
                    color: Colors.black,
                    size: 13,
                  ),
                  label: Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.w700)
                              .fontFamily,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: PalleteColor.primaryPurple,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
                      ),
                      radius: 45,
                    ),
                  ),
                  const SizedBox(
                    width: 35,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rupsha Sarkar",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                  .fontFamily,
                        ),
                      ),
                      Text(
                        "26 years",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 113, 112, 112),
                          fontSize: 16,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.w400)
                                  .fontFamily,
                        ),
                      ),
                      Text(
                        "B+ Blood Group",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 113, 112, 112),
                          fontSize: 16,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.w400)
                                  .fontFamily,
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
