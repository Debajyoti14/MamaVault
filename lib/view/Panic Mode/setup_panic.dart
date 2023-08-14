import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/repository/panic_repository.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/view_model/theme_provider.dart';
import 'package:interrupt/view_model/verified_number_provider.dart';
import 'package:interrupt/resources/components/custom_text_field.dart';
import 'package:interrupt/resources/components/number_verification.dart';
import 'package:interrupt/resources/components/primary_button.dart';
import 'package:provider/provider.dart';
import '../../resources/UI_constraints.dart';

class SetupPanicScreen extends StatefulWidget {
  const SetupPanicScreen({super.key});

  @override
  State<SetupPanicScreen> createState() => _SetupPanicScreenState();
}

class _SetupPanicScreenState extends State<SetupPanicScreen> {
  PanicRepository panicRepository = PanicRepository();
  final TextEditingController _phoneNumber1Controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
    isLoading = false;
  }

  void refresh() {
    fetchNumbers();
  }

  @override
  Widget build(BuildContext context) {
    List allNumbers = Provider.of<NumberProvider>(context).gerVerifiedNumber;
    final themeChange = Provider.of<ThemeProvider>(context);

    BuildContext modalContext = context;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryPurple),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                    height: 520.h,
                    child: SingleChildScrollView(
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
                                              isPurple: themeChange.darkTheme,
                                              validator: (value) {
                                                if (value.toString().isEmpty) {
                                                  return "Phone No. Required";
                                                } else if (value
                                                            .toString()
                                                            .length <
                                                        10 ||
                                                    value.toString().length >
                                                        10) {
                                                  return "It should contain 10 Digits";
                                                }
                                                return null;
                                              },
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
                                            if (formKey.currentState!
                                                .validate()) {
                                              await panicRepository
                                                  .sendNumberDetails(
                                                name: user.displayName ?? "",
                                                number: _phoneNumber1Controller
                                                    .text,
                                                uid: user.uid,
                                              );
                                              await fetchNumbers();
                                              if (context.mounted) {
                                                Navigator.pop(modalContext);
                                              }
                                            }
                                          },
                                        ),
                                        SizedBox(
                                          height: 10.h,
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
