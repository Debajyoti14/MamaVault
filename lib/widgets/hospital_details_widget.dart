import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/color_pallete.dart';

class HospitalDetailsWidget extends StatelessWidget {
  final hospitalName;
  final address;
  final distance;
  final url;
  const HospitalDetailsWidget(
      {super.key, this.hospitalName, this.address, this.distance, this.url});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await launchUrl(Uri.parse(url));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: PalleteColor.primaryPurple),
          color: const Color.fromARGB(255, 231, 231, 255),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hospitalName,
              style: TextStyle(
                fontSize: 18,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              address,
              style: TextStyle(
                fontSize: 14,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              "Distance : $distance km",
              style: TextStyle(
                fontSize: 14,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.w500).fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
