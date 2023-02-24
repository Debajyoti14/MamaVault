import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/color_pallete.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ExpireLink extends StatelessWidget {
  final String link;
  final String date;
  final String views;
  final double percentage;
  final String centerText;
  const ExpireLink({
    super.key,
    required this.link,
    required this.date,
    required this.views,
    required this.percentage,
    required this.centerText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 246, 254),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: PalleteColor.primaryPurple,
          ),
        ),
        child: SingleChildScrollView(
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      link,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)
                                .fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 122, 122, 122),
                      fontSize: 13,
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500)
                              .fontFamily,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye_sharp),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        views,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 122, 122, 122),
                          fontSize: 14,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                  .fontFamily,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                width: 29,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Image.asset('assets/delIcon.png'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
