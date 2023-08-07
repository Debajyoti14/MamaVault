import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/resources/components/hospital_details_widget.dart';
import 'package:interrupt/view/bottom_nav_bar.dart';

class HospitalDetails extends StatelessWidget {
  const HospitalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryPurple,
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute(builder: (context) => const BottomNav()),
            (Route<dynamic> route) => false,
          );
        },
        child: const Icon(Icons.home),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nearest Hospital Details',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontFamily: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                    ).fontFamily,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 30.h),
              const HospitalDetailsWidget(
                hospitalName: "ECHS Polyclinic Salt Lake",
                address:
                    "EM Block, Sector V, Bidhannagar, Kolkata, West Bengal 700091",
                distance: "2.1",
                url: "https://goo.gl/maps/tc1i49JPdjUicaDTA",
              ),
              SizedBox(height: 10.h),
              const HospitalDetailsWidget(
                hospitalName: "Care Hospital",
                address:
                    "Fd216, Flat-1, Sector-III, Salt Lake, BN Block, Sector V, Bidhannagar, Kolkata, West Bengal 700c091",
                distance: "1.7",
                url: "https://goo.gl/maps/azDR4rvrpCU6CC5A6",
              ),
              SizedBox(height: 10.h),
              const HospitalDetailsWidget(
                hospitalName: "Matri Sadan Bidhannagar Municipal Hospital",
                address:
                    "Salt Lake, Main Lane 1, EE-55A, 3rd Ave, EE Block, Sector II, Bidhannagar, Kolkata, West Bengal 700091",
                distance: "1.9",
                url: "https://goo.gl/maps/z4WvvKSnMZ8gUhEF8",
              ),
              SizedBox(height: 10.h),
              const HospitalDetailsWidget(
                hospitalName: "Calcutta Heart Clinic & Hospital",
                address:
                    "3, 1st Cross Rd, HC Block, Sector III, Bidhannagar, Kolkata, West Bengal 700106",
                distance: "2.2",
                url: "https://goo.gl/maps/5oaCfTWLqx1tPmW49",
              ),
              SizedBox(height: 10.h),
              const HospitalDetailsWidget(
                hospitalName: "AMRI Hospital - Salt Lake",
                address:
                    "17,Lane, Central Park Road,Stadium Entrance Road,, 16, Broadway Rd, opposite salt lake, JC Block, Sector III, Bidhannagar, Kolkata, West Bengal 700098",
                distance: "3.8",
                url: "https://goo.gl/maps/U24q2b3ZfhFU3kfa7",
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
