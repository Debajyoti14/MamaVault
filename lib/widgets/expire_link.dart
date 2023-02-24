import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/color_pallete.dart';

import 'package:http/http.dart' as http;


class ExpireLink extends StatefulWidget {
  final String sharedDocID;
  final String link;
  final String date;
  final String views;
  final double percentage;
  final String centerText;
  const ExpireLink({
    super.key,
    required this.link,
    required this.date,
    required this.views,
    required this.percentage,
    required this.centerText,
    required this.sharedDocID,
  });

  @override
  State<ExpireLink> createState() => _ExpireLinkState();
}

class _ExpireLinkState extends State<ExpireLink> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    Future deleteSharedDoc(String sharedDocID, String uid) async {
      try {
        var url =
            Uri.parse("https://delete-shared-doc-s6e4vwvwlq-el.a.run.app/");
        Map data = {
          "uid": uid, // user id
          "share_doc_id": sharedDocID
        };
        var body = json.encode(data);
        var response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: body,
        );
        return response.statusCode;
      } catch (e) {
        print(e.toString());
      }
    }

    Future<void> _showMyDialogForDeleteLinks(
        String sharedDocID, String uid) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            content: const Text('The Shared Link will be deleted permanently'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel',
                    style: TextStyle(color: PalleteColor.primaryPurple)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  deleteSharedDoc(sharedDocID, uid).then((value) {
                    print(value);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

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
                      widget.link,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)
                                .fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    'Will expire on ${widget.date}',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 122, 122, 122),
                      fontSize: 13,
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500)
                              .fontFamily,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye_sharp),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.views,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 122, 122, 122),
                          fontSize: 14,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                  .fontFamily,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                width: 29,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: InkWell(
                  onTap: () {
                    _showMyDialogForDeleteLinks(widget.sharedDocID, user.uid)
                        .then((value) {
                      setState(() {});
                      var snackBar = const SnackBar(
                          content: Text('Link Deleted Successfully'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
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
