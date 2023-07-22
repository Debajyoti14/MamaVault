import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/view_model/verified_number_provider.dart';
import 'package:interrupt/resources/components/custom_text_field.dart';
import 'package:interrupt/resources/components/number_verification.dart';
import 'package:interrupt/resources/components/primary_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../resources/UI_constraints.dart';

class SetupPanicScreen extends StatefulWidget {
  const SetupPanicScreen({super.key});

  @override
  State<SetupPanicScreen> createState() => _SetupPanicScreenState();
}

class _SetupPanicScreenState extends State<SetupPanicScreen> {
  final TextEditingController _phoneNumber1Controller = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  String button1State = 'Initial';
  String button2State = 'Processing';
  String button3State = 'Approved';
  bool isLoading = false;

  @override
  void dispose() {
    _phoneNumber1Controller.dispose();

    super.dispose();
  }

  fetchNumbers() async {
    isLoading = true;
    setState(() {});
    NumberProvider userProvider = Provider.of(context, listen: false);
    await userProvider.fetchAllNumber();
  }

  void refresh() {
    debugPrint("In Refresh");
    fetchNumbers();
    setState(() {});
  }

  Future sendNumberDetails() async {
    var url = Uri.parse('https://verify-mobile-number-s6e4vwvwlq-el.a.run.app');
    Map data = {
      "uid": user.uid,
      "name": user.displayName,
      "number": "+91${_phoneNumber1Controller.text}",
    };
    var body = json.encode(data);
    await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    BuildContext modalContext = context;
    List allNumbers = Provider.of<NumberProvider>(context).gerVerifiedNumber;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Setup Panic Button',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Add numbers to send them message with your location in one click in case of emergency.',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500)
                        .fontFamily,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            (allNumbers.isEmpty)
                ? Column(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 70.h),
                      child: Image.asset('assets/panicPic.png'),
                    ),
                    Text(
                      'Add a number now',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                .fontFamily,
                      ),
                    ),
                    SizedBox(
                      height: 200.h,
                    ),
                  ])
                : SizedBox(
                    height: 550.h,
                    child: Column(
                      children: allNumbers.map<Widget>((data) {
                        return NumberVerify(
                          number: data['number'],
                          status: data['status'],
                          verifyId: data['number_id'],
                          refresh: refresh,
                        );
                      }).toList(),
                    ),
                  ),
            (allNumbers.length < 3)
                ? PrimaryButton(
                    buttonTitle: "Add New Number",
                    onPressed: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          context: context,
                          builder: (BuildContext context) {
                            return BottomSheet(
                              onClosing: () {},
                              builder: (builder) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: defaultPadding,
                                      vertical: 40.h),
                                  child: SizedBox(
                                    height: 150.h +
                                        MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '+91',
                                              style: TextStyle(fontSize: 20.sp),
                                            ),
                                            CustomTextField(
                                              hintText: 'Enter Phone Number',
                                              controller:
                                                  _phoneNumber1Controller,
                                              width: 300.w,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        PrimaryButton(
                                          buttonTitle: "Add Number",
                                          isLoading: isLoading,
                                          onPressed: () async {
                                            await sendNumberDetails();
                                            await fetchNumbers();
                                            if (mounted) {
                                              Navigator.pop(modalContext);
                                            }
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          });
                    })
                : SizedBox(
                    width: double.infinity,
                    height: 57.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        backgroundColor: const Color.fromARGB(177, 79, 79, 79),
                        textStyle: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: const Text("3 Number Done"),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
