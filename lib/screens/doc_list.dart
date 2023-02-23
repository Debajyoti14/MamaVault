import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:provider/provider.dart';

import '../config/color_pallete.dart';
import '../provider/user_provider.dart';

class DocListScreen extends StatefulWidget {
  const DocListScreen({super.key});

  @override
  State<DocListScreen> createState() => _DocListScreenState();
}

class _DocListScreenState extends State<DocListScreen> {
  bool isSelectAll = false;
  List<Widget> docCategoriesTabs = const [
    Tab(child: Text('All')),
    Tab(child: Text('USG Reports')),
    Tab(child: Text('Non-Stress Test')),
    Tab(child: Text('Contraction Stress Test')),
    Tab(child: Text('Doppler Ultrasound Report')),
    Tab(child: Text('Others'))
  ];
  List docCategories = [
    'All',
    'USG Report',
    'Non-Stress Test',
    'Contraction Stress Test',
    'Doppler Ultrasound Report',
    'Others'
  ];

  @override
  Widget build(BuildContext context) {
    List _allUserDocs = Provider.of<UserProvider>(context).getUserDocs;

    List _usgDocs = _allUserDocs.where((element) {
      if (element['doc_type'] == 'USG Report') {
        return true;
      } else {
        return false;
      }
    }).toList();

    List _contractionStressTestDocs = _allUserDocs.where((element) {
      if (element['doc_type'] == 'Contraction Stress Test') {
        return true;
      } else {
        return false;
      }
    }).toList();

    List _dopplerUltraSoundReportDocs = _allUserDocs.where((element) {
      if (element['doc_type'] == 'Doppler Ultrasound Report') {
        return true;
      } else {
        return false;
      }
    }).toList();

    List _otherDocs = _allUserDocs.where((element) {
      if (element['doc_type'] == 'Others') {
        return true;
      } else {
        return false;
      }
    }).toList();

    return SafeArea(
        child: DefaultTabController(
      length: docCategoriesTabs.length,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: PalleteColor.bodyTextColorLight,
          bottom: TabBar(
            indicatorColor: PalleteColor.primaryPurple,
            labelStyle: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily:
                  GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14.0,
            ),
            labelColor: Colors.black,
            isScrollable: true,
            tabs: docCategoriesTabs,
          ),
          toolbarTextStyle:
              GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme)
                  .bodyMedium,
          titleTextStyle:
              GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme)
                  .titleLarge,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      value: isSelectAll,
                      shape: const CircleBorder(),
                      onChanged: (bool? value) {
                        setState(() {
                          isSelectAll = value!;
                        });
                      },
                    ),
                    const Text(
                      'Select All',
                      style: TextStyle(color: PalleteColor.primaryPurple),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: Column(
                          children: [
                            for (var doc in _allUserDocs)
                              Column(
                                children: [
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    child: documentIndividual(
                                      documentTitle: doc['doc_title'],
                                      time: doc['timeline_time'],
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: defaultPadding),
                        child: ListView.builder(
                            itemCount: _usgDocs.length,
                            itemBuilder: (builder, index) {
                              final doc = _allUserDocs[index];

                              return InkWell(
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    documentIndividual(
                                      documentTitle: doc['doc_title'],
                                      time: doc['timeline_time'],
                                    ),
                                  ],
                                ),
                              );
                            }),
                        // child: Column(
                        //   children: [
                        //     for (var doc in _usgDocs)
                        //       Column(
                        //         children: [
                        //           const SizedBox(height: 10),
                        //           documentIndividual(
                        //             documentTitle: doc['doc_title'],
                        //             time: doc['timeline_time'],
                        //           ),
                        //         ],
                        //       )
                        //   ],
                        // ),
                      ),
                      const Center(child: Text('Contraction Stress Test')),
                      const Center(child: Text('Doppler Ultrasound Report')),
                      const Center(child: Text('Others')),
                      const Center(child: Text('Others')),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.share,
                        color: PalleteColor.primaryPurple,
                      ),
                      Text('Share')
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.download,
                        color: PalleteColor.primaryPurple,
                      ),
                      const Text('Download')
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text('Delete')
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}

Widget documentIndividual(
    {required String documentTitle, required String time}) {
  return Container(
    width: double.infinity,
    height: 70,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 223, 223, 247),
      border: Border.all(width: 2, color: PalleteColor.primaryPurple),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    child: Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              documentTitle,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        )
      ],
    ),
  );
}
