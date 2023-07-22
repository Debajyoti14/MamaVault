import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/view/signin_page.dart';
import 'package:onboarding/onboarding.dart';

import '../../resources/components/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late Material materialButton;
  late int index;
  final onboardingPagesList = [
    PageModel(
      widget: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/onboarding-1.png',
              height: 400.h,
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Keep all your Doctors Docs under one roof',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                        .fontFamily,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Categorize and store all your Doctors Document and also share it by one click',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: const Color.fromARGB(203, 108, 108, 108),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    PageModel(
      widget: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/onboarding-2.png',
              height: 400.h,
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Inform Close ones in distress',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                        .fontFamily,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'In time of distress or any panic situation, inform your closest one at click',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: const Color.fromARGB(203, 108, 108, 108),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    PageModel(
      widget: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          children: [
            Image.asset(
              'assets/onboarding-3.png',
              height: 400.h,
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create Memories and Cherish them',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                        .fontFamily,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Add your sweet times in our apps so that later you can cherish it.',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: const Color.fromARGB(203, 108, 108, 108),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    PageModel(
      widget: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Container(
                  color: AppColors.primaryPurple,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/onboarding-4.png',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding, vertical: 50.h),
                color: AppColors.bodyTextColorLight,
                child: const Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'All time friend in Pregnancy',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'The only app you need in time of your pregnancy.',
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      elevation: 3,
      borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      color: AppColors.primaryPurple,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index++;
            setIndex(index);
          }
        },
        child: const Padding(
          padding: EdgeInsets.all(15),
          child: Icon(
            Icons.navigate_next,
            color: AppColors.bodyTextColorLight,
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
    return Material(
      child: SizedBox(
        width: 150,
        child: PrimaryButton(
            buttonTitle: 'Get Started',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(builder: (_) => const SignInPage()),
                  (route) => false);
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyTextColorLight,
      body: Onboarding(
        pages: onboardingPagesList,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.bodyTextColorLight,
            ),
            child: ColoredBox(
              color: AppColors.bodyTextColorLight,
              child: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIndicator(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      indicator: Indicator(
                        closedIndicator: const ClosedIndicator(
                            color: Colors.white, borderWidth: 4),
                        activeIndicator: const ActiveIndicator(
                            color: AppColors.primaryPurple, borderWidth: 6),
                        indicatorDesign: IndicatorDesign.line(
                          lineDesign: LineDesign(
                            lineType: DesignType.line_uniform,
                            lineWidth: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ),
                      ),
                    ),
                    index == pagesLength - 1
                        ? _signupButton
                        : _skipButton(setIndex: setIndex)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


//  widget: SizedBox(
//         height: double.infinity,
//         child: DecoratedBox(
//           decoration: BoxDecoration(
//             color: AppColors.primaryPurple,
//             border: Border.all(
//               width: 0.0,
//               color: AppColors.bodyTextColorLight,
//             ),
//           ),
//           child: Container(
//             decoration: const BoxDecoration(color: AppColors.primaryPurple),
//             child: SingleChildScrollView(
//               controller: ScrollController(),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ClipRRect(
//                     borderRadius: const BorderRadius.all(Radius.circular(30)),
//                     child: Container(
//                       color: AppColors.primaryPurple,
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 55.0,
//                         vertical: 90.0,
//                       ),
//                       child: Image.asset(
//                         'assets/onboarding-4.png',
//                         height: 200,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration:
//                         const BoxDecoration(color: AppColors.primaryPurple),
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: defaultPadding, vertical: 50),
//                     // color: AppColors.bodyTextColorLight,
//                     child: Column(
//                       children: [
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'All time friend in Pregnancy',
//                             style: TextStyle(
//                               fontSize: 28,
//                               fontFamily: GoogleFonts.poppins(
//                                       fontWeight: FontWeight.bold)
//                                   .fontFamily,
//                               color: Colors.black,
//                             ),
//                             textAlign: TextAlign.left,
//                           ),
//                         ),
//                         const SizedBox(height: 30),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             'The only app you need in time of your pregnancy.',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontFamily: GoogleFonts.poppins().fontFamily,
//                               color: const Color.fromARGB(203, 108, 108, 108),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),