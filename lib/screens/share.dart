import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/config/color_pallete.dart';
import 'package:interrupt/widgets/expire_link.dart';
// import 'package:interrupt/widgets/expire_link.dart';
import 'package:interrupt/widgets/primary_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../provider/user_provider.dart';
import '../provider/expire_provider.dart';
import '../widgets/custom_text_field.dart';

class Share extends StatefulWidget {
  const Share({super.key});

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  final expireTime = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  bool shareProfile = true;
  List<String> allDocId = [];
  List allExpireLinks = [];

  fetchExpire() async {
    ExpireProvider userProvider = Provider.of(context, listen: false);
    await userProvider.fetchExpiryDetails();
  }

  Future sendDetails(List allDoc) async {
    allDoc.forEach((doc) {
      allDocId.add(doc['doc_id']);
    });
    var url = Uri.parse("https://expiry-system-s6e4vwvwlq-el.a.run.app");
    Map data = {
      "uid": user.uid, // user id
      "isprofile": shareProfile, // shares profile
      "ttl": int.parse(expireTime.text), //in seconds
      "shared_docs": allDocId,
    };
    var body = json.encode(data);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    await fetExpireDetails();
    return response.body;
  }

  Future fetExpireDetails() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      CollectionReference docRef = firestore
          .collection('users')
          .doc(user.uid)
          .collection('shared_links');
      QuerySnapshot querySnapshot = await docRef.get();
      final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      allExpireLinks = allData;
    } catch (e) {
      return;
    }
  }

  @override
  initState() {
    super.initState();
    fetExpireDetails();
  }

  @override
  Widget build(BuildContext context) {
    List allUserDocs = Provider.of<UserProvider>(context).getUserDocs;
    List allExpireDocs = Provider.of<ExpireProvider>(context).getExpiryDetails;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                "Share",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              PrimaryIconButton(
                buttonTitle: "Shared Doc",
                buttonIcon: const FaIcon(FontAwesomeIcons.share),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter myState) {
                          return BottomSheet(
                            onClosing: () {},
                            builder: (BuildContext context) {
                              return SizedBox(
                                height: 350,
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: defaultPadding,
                                      right: defaultPadding,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        Text(
                                          'Expiry Time',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.bold)
                                                .fontFamily,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        CustomTextField(
                                          hintText: "Enter Expiry time",
                                          controller: expireTime,
                                          validator: (value) {
                                            if (value.toString().isEmpty) {
                                              return 'Time Required';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Share Profile",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontFamily: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w500)
                                                    .fontFamily,
                                              ),
                                            ),
                                            Switch(
                                              value: shareProfile,
                                              activeColor:
                                                  PalleteColor.primaryPurple,
                                              onChanged: (bool value) {
                                                if (mounted) {
                                                  setState(() {
                                                    shareProfile = value;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                        PrimaryIconButton(
                                          buttonTitle: "Next",
                                          buttonIcon: const FaIcon(
                                            FontAwesomeIcons.link,
                                            size: 18,
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            var res =
                                                await sendDetails(allUserDocs);
                                            final Map parsed = json.decode(res);
                                            print(parsed['share_doc_link']);
                                            fetchExpire();
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 60,
              ),
              Container(
                height: 3,
                decoration: const BoxDecoration(color: Colors.black),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Share Doc",
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: allExpireDocs.map<Widget>((data) {
                  return ExpireLink(
                      link: data['shared_link'],
                      date: data['expiry_time'].toString(),
                      views: data['views'].toString(),
                      percentage: 0.72,
                      centerText: "22:00");
                }).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
