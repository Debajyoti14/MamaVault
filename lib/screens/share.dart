import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/widgets/expire_link.dart';
import 'package:interrupt/widgets/primary_icon_button.dart';

class Share extends StatelessWidget {
  const Share({super.key});

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
                "Share Doc",
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
                onPressed: () {},
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
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
              ),
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
              ),
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
              ),
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
              ),
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
              ),
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
              ),
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
              ),
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
              ),
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
              ),
              const ExpireLink(
                centerText: '00:23',
                date: '16-09-2022',
                link: 'https://www.google.com',
                percentage: 0.72,
                views: '12',
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
}
