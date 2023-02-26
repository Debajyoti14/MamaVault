import 'dart:convert';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/config/color_pallete.dart';
import 'package:interrupt/screens/Panic%20Mode/hospital_details.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;

class PanicModeMessageScreen extends StatefulWidget {
  const PanicModeMessageScreen({super.key});

  @override
  State<PanicModeMessageScreen> createState() => _PanicModeMessageScreenState();
}

class _PanicModeMessageScreenState extends State<PanicModeMessageScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  void initState() {
    sendPanicRequest();
    super.initState();
  }

  Future sendPanicRequest() async {
    var url = Uri.parse('https://panic-s6e4vwvwlq-el.a.run.app');
    Map data = {
      "uid": user.uid,
      "name": user.displayName,
      "location_link": "Anadapur, Kolkata",
    };
    var body = json.encode(data);
    await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    if (mounted) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => const HospitalDetails(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Panic Mode',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50),
            Lottie.network(
              'https://assets7.lottiefiles.com/private_files/lf30_dfxejf4d.json',
              width: 300,
            ),
            const SizedBox(height: 30),
            const Text(
              'Sending Emergency Message',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: PalleteColor.primaryPurple,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
