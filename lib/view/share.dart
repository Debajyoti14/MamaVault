import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/utils/utils.dart';
import 'package:interrupt/view/doc_list.dart';
import 'package:interrupt/resources/components/expire_link.dart';
import 'package:interrupt/resources/components/primary_icon_button.dart';
import 'package:interrupt/view_model/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../utils/date_formatter.dart';
import '../view_model/expire_provider.dart';

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
  final success = const SnackBar(
    content: Text('Copied to clipboard'),
  );

  fetchExpire() async {
    ExpireProvider userProvider = Provider.of(context, listen: false);
    await userProvider.fetchExpiryDetails();
  }

  Future sendDetails(List allDoc) async {
    for (var doc in allDoc) {
      allDocId.add(doc['doc_id']);
    }
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
    fetchExpire();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List allExpireDocs = Provider.of<ExpireProvider>(context).getExpiryDetails;
    final themeChange = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
              ),
              Text(
                "Share",
                style: TextStyle(
                  fontSize: 32.sp,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
              SizedBox(
                height: 60.h,
              ),
              PrimaryIconButton(
                buttonTitle: "Share Docs",
                buttonIcon: const FaIcon(FontAwesomeIcons.share),
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => const DocListScreen()));
                },
              ),
              SizedBox(
                height: 60.h,
              ),
              Container(
                height: 3.h,
                decoration: BoxDecoration(
                    color: themeChange.darkTheme ? Colors.white : Colors.black),
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                "Shared Links",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              allExpireDocs.isNotEmpty
                  ? Column(
                      children: allExpireDocs.map<Widget>((data) {
                        String formattedDate =
                            format12hourTime(data['expiry_time']);
                        return GestureDetector(
                          onTap: () {
                            FlutterClipboard.copy(data['shared_link']).then(
                                (value) =>
                                    Utils.toastMessage("Copied to Clipboard"));
                          },
                          child: ExpireLink(
                            sharedDocID: data['shared_doc_id'],
                            link: data['shared_link'],
                            date: formattedDate,
                            views: data['views'].toString(),
                          ),
                        );
                      }).toList(),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: const Center(
                        child: Text('No Active Shared Links Available '),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
