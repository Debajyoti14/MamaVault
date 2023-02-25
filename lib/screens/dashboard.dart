import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/date_formatter.dart';
import 'package:interrupt/provider/user_provider.dart';
import 'package:interrupt/screens/Panic%20Mode/panic_mode_timer.dart';
import 'package:interrupt/screens/profile.dart';
import 'package:interrupt/screens/upload_document.dart';
import 'package:interrupt/widgets/primary_icon_button.dart';
import 'package:provider/provider.dart';

import '../config/UI_constraints.dart';
import '../config/color_pallete.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  late List<dynamic> timelineData;

  Future fetchTimeline(List allDocs) async {
    var url = Uri.parse(
        "https://us-central1-mamavault-019.cloudfunctions.net/getTimeline");
    Map data = {
      "documents": allDocs //array of all documents
    };
    var body = json.encode(data);
    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    final responseData = json.decode(response.body);
    return responseData;
  }

  @override
  Widget build(BuildContext context) {
    List allUserDocs = Provider.of<UserProvider>(context).getUserDocs;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ).fontFamily,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const Profile(),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: PalleteColor.primaryPurple,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            user.photoURL!,
                          ),
                          radius: 27,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 235, 233),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  height: 104,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Panic Button',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            width: 153,
                            child: Text(
                              'Panic Button is made for emergency situation so be careful',
                              style: TextStyle(fontSize: 10),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 136,
                        height: 50,
                        child: PrimaryIconButton(
                          backgroundColor: Colors.red,
                          buttonTitle: 'Panic',
                          buttonIcon: const FaIcon(FontAwesomeIcons.bell),
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => const PanicModeScreen()));
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: FutureBuilder<dynamic>(
                      future: fetchTimeline(allUserDocs),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<dynamic> snapshot,
                      ) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: PalleteColor.primaryPurple,
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Text('Error');
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final singletimeline = snapshot.data[index];
                                  final formattedTime =
                                      format12hourTime(singletimeline['time']);
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          formattedTime,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                            ).fontFamily,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color:
                                                    PalleteColor.primaryPurple),
                                            color: const Color.fromARGB(
                                                255, 231, 231, 255),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(8)),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'Document Attached',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  for (var doc
                                                      in singletimeline[
                                                          'document'])
                                                    Column(
                                                      children: [
                                                        doc['doc_format'] ==
                                                                'image/jpeg'
                                                            ? Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    width: 2,
                                                                    color: PalleteColor
                                                                        .primaryPurple,
                                                                  ),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                ),
                                                                child: Image
                                                                    .network(
                                                                  doc['doc_url'],
                                                                  width: 83,
                                                                  height: 64,
                                                                ),
                                                              )
                                                            : Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(8),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            10),
                                                                  ),
                                                                  border: Border
                                                                      .all(
                                                                    width: 2,
                                                                    color: PalleteColor
                                                                        .primaryPurple,
                                                                  ),
                                                                ),
                                                                child: Image
                                                                    .network(
                                                                  'https://www.woschool.com/wp-content/uploads/2020/09/png-transparent-pdf-icon-illustration-adobe-acrobat-portable-document-format-computer-icons-adobe-reader-file-pdf-icon-miscellaneous-text-logo.png',
                                                                  width: 93,
                                                                  height: 64,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                            height: 5),
                                                        Text(
                                                          doc['doc_title'],
                                                        )
                                                      ],
                                                    )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return const Text('Empty data');
                          }
                        } else {
                          return Text('State: ${snapshot.connectionState}');
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(CupertinoPageRoute(
              builder: (context) => const DocumentUpload(),
            ));
          },
          backgroundColor: PalleteColor.primaryPurple,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
