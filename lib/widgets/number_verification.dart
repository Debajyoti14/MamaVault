import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/color_pallete.dart';
import 'package:http/http.dart' as http;

class NumberVerify extends StatelessWidget {
  final String number;
  final String status;
  final String verifyId;
  final Function refresh;

  const NumberVerify({
    super.key,
    required this.number,
    required this.status,
    required this.verifyId,
    required this.refresh,
  });

  Future sendPanicRequest() async {
    final user = FirebaseAuth.instance.currentUser!;
    var url =
        Uri.parse('https://update-verification-status-s6e4vwvwlq-el.a.run.app');
    Map data = {
      "uid": user.uid, // user id
      "verification_id": verifyId, // mobile number id
      "action": "Delete"
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 245, 246, 254),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: PalleteColor.primaryPurple,
          ),
        ),
        child: SingleChildScrollView(
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      number,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)
                                .fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (status == "Waiting for confirmation")
                                ? Colors.yellow
                                : Colors.green),
                        height: 12,
                        width: 12,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 122, 122, 122),
                          fontSize: 13,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                  .fontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 29,
              ),
              InkWell(
                onTap: () async {
                  await sendPanicRequest();
                  refresh();
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Image.asset('assets/delIcon.png'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
