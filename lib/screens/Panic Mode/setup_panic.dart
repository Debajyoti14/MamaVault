import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/provider/verified_number_provider.dart';
import 'package:interrupt/widgets/custom_text_field.dart';
import 'package:interrupt/widgets/number_verification.dart';
import 'package:interrupt/widgets/primary_button.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../../config/UI_constraints.dart';

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

  @override
  void dispose() {
    _phoneNumber1Controller.dispose();

    super.dispose();
  }

  fetchNumbers() async {
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
  }

  @override
  Widget build(BuildContext context) {
    BuildContext modalContext = context;
    List allNumbers = Provider.of<NumberProvider>(context).gerVerifiedNumber;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Setup Panic Button',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'Add numbers to send them message with your location in one click in case of emergency.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.w500)
                        .fontFamily,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            (allNumbers.isEmpty)
                ? Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70),
                      child: Image.asset('assets/panicPic.png'),
                    ),
                    Text(
                      'Add a number now',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                .fontFamily,
                      ),
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                  ])
                : SizedBox(
                    height: 550,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: defaultPadding, vertical: 40),
                                  child: SizedBox(
                                    height: 240,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              '+91',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            CustomTextField(
                                              hintText: 'Enter Phone Number',
                                              controller:
                                                  _phoneNumber1Controller,
                                              width: 300,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        PrimaryButton(
                                          buttonTitle: "Add Number",
                                          onPressed: () async {
                                            await sendNumberDetails();
                                            fetchNumbers();
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
                    height: 57,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        backgroundColor: const Color.fromARGB(177, 79, 79, 79),
                        textStyle: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("3 Number Done"),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
