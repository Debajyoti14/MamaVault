import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interrupt/resources/colors.dart';

import '../resources/UI_constraints.dart';
import 'doc_list.dart';

class DocsGalleryScreen extends StatelessWidget {
  const DocsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List docCategories = [
      'USG Reports',
      'Non-Stress Test',
      'Contraction Stress Test',
      'Doppler Ultrasound Report',
      'Others'
    ];
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Docs Gallery',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: docCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const DocListScreen()),
                          );
                        },
                        child: Column(
                          children: [
                            FaIcon(
                              FontAwesomeIcons.solidFolder,
                              color: AppColors.primaryPurple,
                              size: 122.w,
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              docCategories[index],
                              style: TextStyle(
                                  fontSize: 14.sp, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
