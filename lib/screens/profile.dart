import 'package:accordion/accordion.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/config/color_pallete.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(user.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              backgroundColor: PalleteColor.bodyTextColorLight,
              body: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: defaultPadding),
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
                              fontFamily: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)
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
                                fontFamily: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700)
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
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: PalleteColor.primaryPurple,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  user.photoURL!,
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
                                  data['name'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500)
                                        .fontFamily,
                                  ),
                                ),
                                Text(
                                  "${data['age']} years",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 113, 112, 112),
                                    fontSize: 16,
                                    fontFamily: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400)
                                        .fontFamily,
                                  ),
                                ),
                                Text(
                                  "B+ Blood Group",
                                  style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 113, 112, 112),
                                    fontSize: 16,
                                    fontFamily: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400)
                                        .fontFamily,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Row(
                          children: [
                            CircularPercentIndicator(
                              curve: Curves.easeIn,
                              radius: 50.0,
                              lineWidth: 20.0,
                              percent: 0.7,
                              progressColor: PalleteColor.primaryPurple,
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "7 weeks 2 days",
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontFamily: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500)
                                        .fontFamily,
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "Your baby just got a heart ❤️",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        const Color.fromARGB(255, 91, 89, 89),
                                    fontFamily: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500)
                                        .fontFamily,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Accordion(
                          contentBackgroundColor:
                              const Color.fromARGB(255, 245, 246, 254),
                          headerBackgroundColor:
                              const Color.fromARGB(255, 245, 246, 254),
                          headerPadding: const EdgeInsets.symmetric(
                              vertical: 24, horizontal: 18),
                          children: [
                            AccordionSection(
                              contentBorderColor:
                                  const Color.fromARGB(255, 245, 246, 254),
                              leftIcon: const FaIcon(FontAwesomeIcons.pills,
                                  color: Color.fromARGB(255, 11, 99, 3)),
                              rightIcon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black54, size: 20),
                              header: Text(
                                "Medicines",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 73, 72, 72),
                                  fontSize: 21,
                                  fontFamily: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500)
                                      .fontFamily,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data['medicines '].toString(),
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 73, 72, 72),
                                        fontSize: 14,
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500)
                                            .fontFamily,
                                      ),
                                    ),
                                    Text(
                                      "Paracetamol",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 73, 72, 72),
                                        fontSize: 14,
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500)
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AccordionSection(
                              contentBorderColor:
                                  const Color.fromARGB(255, 245, 246, 254),
                              leftIcon: const FaIcon(
                                FontAwesomeIcons.virusCovid,
                                color: Color.fromARGB(255, 142, 55, 55),
                              ),
                              rightIcon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black54, size: 20),
                              header: Text(
                                "Allergies",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 73, 72, 72),
                                  fontSize: 21,
                                  fontFamily: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500)
                                      .fontFamily,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Medoc T",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 73, 72, 72),
                                        fontSize: 14,
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500)
                                            .fontFamily,
                                      ),
                                    ),
                                    Text(
                                      "Pentopra Jol",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 73, 72, 72),
                                        fontSize: 14,
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500)
                                            .fontFamily,
                                      ),
                                    ),
                                    Text(
                                      "Paracetamol",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 73, 72, 72),
                                        fontSize: 14,
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500)
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AccordionSection(
                              contentBorderColor:
                                  const Color.fromARGB(255, 245, 246, 254),
                              leftIcon: const FaIcon(
                                FontAwesomeIcons.disease,
                                color: Color.fromARGB(255, 106, 120, 11),
                              ),
                              rightIcon: const Icon(Icons.keyboard_arrow_down,
                                  color: Colors.black54, size: 20),
                              header: Text(
                                "Diseases",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 73, 72, 72),
                                  fontSize: 21,
                                  fontFamily: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500)
                                      .fontFamily,
                                ),
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Medoc T",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 73, 72, 72),
                                        fontSize: 14,
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500)
                                            .fontFamily,
                                      ),
                                    ),
                                    Text(
                                      "Pentopra Jol",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 73, 72, 72),
                                        fontSize: 14,
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500)
                                            .fontFamily,
                                      ),
                                    ),
                                    Text(
                                      "Paracetamol",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 73, 72, 72),
                                        fontSize: 14,
                                        fontFamily: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500)
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
