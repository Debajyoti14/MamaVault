import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/widgets/hospital_details_widget.dart';

class HospitalDetails extends StatelessWidget {
  const HospitalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nearest Hospital Details',
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ).fontFamily,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(height: 30),
              const HospitalDetailsWidget(
                hospitalName: "ECHS Polyclinic Salt Lake",
                address:
                    "EM Block, Sector V, Bidhannagar, Kolkata, West Bengal 700091",
                distance: "2.1",
                url: "https://goo.gl/maps/tc1i49JPdjUicaDTA",
              ),
              const SizedBox(height: 10),
              const HospitalDetailsWidget(
                hospitalName: "Care Hospital",
                address:
                    "Fd216, Flat-1, Sector-III, Salt Lake, BN Block, Sector V, Bidhannagar, Kolkata, West Bengal 700c091",
                distance: "1.7",
                url: "https://goo.gl/maps/azDR4rvrpCU6CC5A6",
              ),
              const SizedBox(height: 10),
              const HospitalDetailsWidget(
                hospitalName: "Matri Sadan Bidhannagar Municipal Hospital",
                address:
                    "Salt Lake, Main Lane 1, EE-55A, 3rd Ave, EE Block, Sector II, Bidhannagar, Kolkata, West Bengal 700091",
                distance: "1.9",
                url: "https://goo.gl/maps/z4WvvKSnMZ8gUhEF8",
              ),
              const SizedBox(height: 10),
              const HospitalDetailsWidget(
                hospitalName: "Calcutta Heart Clinic & Hospital",
                address:
                    "3, 1st Cross Rd, HC Block, Sector III, Bidhannagar, Kolkata, West Bengal 700106",
                distance: "2.2",
                url: "https://goo.gl/maps/5oaCfTWLqx1tPmW49",
              ),
              const SizedBox(height: 10),
              const HospitalDetailsWidget(
                hospitalName: "AMRI Hospital - Salt Lake",
                address:
                    "17,Lane, Central Park Road,Stadium Entrance Road,, 16, Broadway Rd, opposite salt lake, JC Block, Sector III, Bidhannagar, Kolkata, West Bengal 700098",
                distance: "3.8",
                url: "https://goo.gl/maps/U24q2b3ZfhFU3kfa7",
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
