// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:interrupt/model/hospital_model.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/resources/components/hospital_details_widget.dart';
import 'package:interrupt/view/bottom_nav_bar.dart';

class HospitalDetails extends StatelessWidget {
  final List<Results>? results;
  const HospitalDetails({
    Key? key,
    this.results,
  }) : super(key: key);

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
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 50.h,
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
              SizedBox(
                height: 10.h,
              ),
              (results != null && results!.isNotEmpty)
                  ? ListView.builder(
                      itemCount: results?.length ?? 0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final hospital = results?[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: HospitalDetailsWidget(
                            hospitalName: hospital?.poi?.name,
                            address: hospital?.address?.freeformAddress,
                            distance: (hospital?.dist ?? 0).toStringAsFixed(1),
                            url:
                                "http://www.google.com/maps/place/${hospital?.position?.lat},${hospital?.position?.lon}/@${hospital?.position?.lat},${hospital?.position?.lon},17z",
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        "No Hospitals found nearby",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.bold)
                                  .fontFamily,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
