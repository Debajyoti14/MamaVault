import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../config/color_pallete.dart';
import '../provider/user_provider.dart';
import 'individual_doc.dart';

class DocListScreen extends StatefulWidget {
  const DocListScreen({super.key});

  @override
  State<DocListScreen> createState() => _DocListScreenState();
}

class _DocListScreenState extends State<DocListScreen> {
  bool isSelectAll = false;
  bool isSelectAllUSG = false;
  bool isSelectNonStressThings = false;
  bool isSelectContractionStressThings = false;
  bool isSelectDopplerUltrasoundReport = false;
  bool isSelectOthers = false;
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

  List selectedItems = [];

  @override
  Widget build(BuildContext context) {
    List allUserDocs = Provider.of<UserProvider>(context).getUserDocs;

    List usgDocs = allUserDocs.where((element) {
      if (element['doc_type'] == 'USG Report') {
        return true;
      } else {
        return false;
      }
    }).toList();

    List nonStressTestDocs = allUserDocs.where((element) {
      if (element['doc_type'] == 'Non-Stress Test') {
        return true;
      } else {
        return false;
      }
    }).toList();

    List contractionStressTestDocs = allUserDocs.where((element) {
      if (element['doc_type'] == 'Contraction Stress Test') {
        return true;
      } else {
        return false;
      }
    }).toList();

    List dopplerUltraSoundReportDocs = allUserDocs.where((element) {
      if (element['doc_type'] == 'Doppler Ultrasound Report') {
        return true;
      } else {
        return false;
      }
    }).toList();

    List otherDocs = allUserDocs.where((element) {
      if (element['doc_type'] == 'Others') {
        return true;
      } else {
        return false;
      }
    }).toList();

    print(selectedItems);

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
            unselectedLabelStyle: TextStyle(
              fontSize: 14.0,
              fontFamily: GoogleFonts.poppins().fontFamily,
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(
                    children: [
                      allUserDocs.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                              child: Column(
                                children: [
                                  allUserDocs.isNotEmpty
                                      ? Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              activeColor:
                                                  PalleteColor.primaryPurple,
                                              value: isSelectAll,
                                              shape: const CircleBorder(),
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isSelectAll = value!;

                                                  if (value == true) {
                                                    selectedItems.clear();
                                                    setState(() {
                                                      for (var item
                                                          in allUserDocs) {
                                                        selectedItems.add(
                                                            item["doc_id"]);
                                                      }
                                                    });
                                                  } else {
                                                    selectedItems = [];
                                                  }
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Select All',
                                              style: TextStyle(
                                                  color: PalleteColor
                                                      .primaryPurple),
                                            )
                                          ],
                                        )
                                      : Container(),
                                  for (var doc in allUserDocs)
                                    Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                            child: IndividualDoc(
                                          docData: doc,
                                          documentID: doc['doc_id'],
                                          callback: (val, isSelectAllfr) {
                                            selectedItems = val;
                                            isSelectAll = isSelectAllfr;
                                            setState(() {});
                                          },
                                          selectedDocuments: selectedItems,
                                          isSelectedDoc: isSelectAll,
                                          documentTitle: doc['doc_title'],
                                          time: doc['timeline_time'],
                                        )),
                                      ],
                                    )
                                ],
                              ),
                            )
                          : Lottie.network(
                              'https://assets3.lottiefiles.com/packages/lf20_aBYmBC.json'),
                      usgDocs.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                              child: Column(
                                children: [
                                  usgDocs.isNotEmpty
                                      ? Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              activeColor:
                                                  PalleteColor.primaryPurple,
                                              value: isSelectAllUSG,
                                              shape: const CircleBorder(),
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isSelectAllUSG = value!;
                                                  if (value == true) {
                                                    setState(() {
                                                      for (var item
                                                          in usgDocs) {
                                                        selectedItems.add(
                                                            item["doc_id"]);
                                                      }
                                                    });
                                                  } else {
                                                    for (var item in usgDocs) {
                                                      selectedItems.remove(
                                                          item['doc_id']);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Select All',
                                              style: TextStyle(
                                                  color: PalleteColor
                                                      .primaryPurple),
                                            )
                                          ],
                                        )
                                      : Container(),
                                  for (var doc in usgDocs)
                                    Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                            child: IndividualDoc(
                                          docData: doc,
                                          documentID: doc['doc_id'],
                                          callback: (val, isSelectAll) {
                                            selectedItems = val;
                                            isSelectAllUSG = isSelectAll;
                                            setState(() {});
                                          },
                                          selectedDocuments: selectedItems,
                                          isSelectedDoc: isSelectAllUSG,
                                          documentTitle: doc['doc_title'],
                                          time: doc['timeline_time'],
                                        )),
                                      ],
                                    )
                                ],
                              ),
                            )
                          : Lottie.network(
                              'https://assets3.lottiefiles.com/packages/lf20_aBYmBC.json'),
                      nonStressTestDocs.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                              child: Column(
                                children: [
                                  nonStressTestDocs.isNotEmpty
                                      ? Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              activeColor:
                                                  PalleteColor.primaryPurple,
                                              value: isSelectNonStressThings,
                                              shape: const CircleBorder(),
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isSelectNonStressThings =
                                                      value!;

                                                  if (value == true) {
                                                    setState(() {
                                                      for (var item
                                                          in nonStressTestDocs) {
                                                        selectedItems.add(
                                                            item["doc_id"]);
                                                      }
                                                    });
                                                  } else {
                                                    for (var item
                                                        in nonStressTestDocs) {
                                                      selectedItems.remove(
                                                          item['doc_id']);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Select All',
                                              style: TextStyle(
                                                  color: PalleteColor
                                                      .primaryPurple),
                                            )
                                          ],
                                        )
                                      : Container(),
                                  for (var doc in nonStressTestDocs)
                                    Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                            child: IndividualDoc(
                                          docData: doc,
                                          documentID: doc['doc_id'],
                                          callback: (val, isSelectAll) {
                                            selectedItems = val;
                                            isSelectNonStressThings =
                                                isSelectAll;
                                            setState(() {});
                                          },
                                          selectedDocuments: selectedItems,
                                          isSelectedDoc:
                                              isSelectNonStressThings,
                                          documentTitle: doc['doc_title'],
                                          time: doc['timeline_time'],
                                        )),
                                      ],
                                    )
                                ],
                              ),
                            )
                          : Lottie.network(
                              'https://assets3.lottiefiles.com/packages/lf20_aBYmBC.json'),
                      contractionStressTestDocs.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                              child: Column(
                                children: [
                                  contractionStressTestDocs.isNotEmpty
                                      ? Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              activeColor:
                                                  PalleteColor.primaryPurple,
                                              value:
                                                  isSelectContractionStressThings,
                                              shape: const CircleBorder(),
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isSelectContractionStressThings =
                                                      value!;

                                                  if (value == true) {
                                                    setState(() {
                                                      for (var item
                                                          in contractionStressTestDocs) {
                                                        selectedItems.add(
                                                            item["doc_id"]);
                                                      }
                                                    });
                                                  } else {
                                                    for (var item
                                                        in contractionStressTestDocs) {
                                                      selectedItems.remove(
                                                          item['doc_id']);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Select All',
                                              style: TextStyle(
                                                  color: PalleteColor
                                                      .primaryPurple),
                                            )
                                          ],
                                        )
                                      : Container(),
                                  for (var doc in contractionStressTestDocs)
                                    Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                            child: IndividualDoc(
                                          docData: doc,
                                          documentID: doc['doc_id'],
                                          callback: (val, isSelectAll) {
                                            selectedItems = val;
                                            isSelectContractionStressThings =
                                                isSelectAll;
                                            setState(() {});
                                          },
                                          selectedDocuments: selectedItems,
                                          isSelectedDoc:
                                              isSelectContractionStressThings,
                                          documentTitle: doc['doc_title'],
                                          time: doc['timeline_time'],
                                        )),
                                      ],
                                    )
                                ],
                              ),
                            )
                          : Lottie.network(
                              'https://assets3.lottiefiles.com/packages/lf20_aBYmBC.json'),
                      dopplerUltraSoundReportDocs.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                              child: Column(
                                children: [
                                  dopplerUltraSoundReportDocs.isNotEmpty
                                      ? Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              activeColor:
                                                  PalleteColor.primaryPurple,
                                              value:
                                                  isSelectDopplerUltrasoundReport,
                                              shape: const CircleBorder(),
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isSelectDopplerUltrasoundReport =
                                                      value!;

                                                  if (value == true) {
                                                    setState(() {
                                                      for (var item
                                                          in dopplerUltraSoundReportDocs) {
                                                        selectedItems.add(
                                                            item["doc_id"]);
                                                      }
                                                    });
                                                  } else {
                                                    for (var item
                                                        in dopplerUltraSoundReportDocs) {
                                                      selectedItems.remove(
                                                          item['doc_id']);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Select All',
                                              style: TextStyle(
                                                  color: PalleteColor
                                                      .primaryPurple),
                                            )
                                          ],
                                        )
                                      : Container(),
                                  for (var doc in dopplerUltraSoundReportDocs)
                                    Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                            child: IndividualDoc(
                                          docData: doc,
                                          documentID: doc['doc_id'],
                                          callback: (val, isSelectAll) {
                                            selectedItems = val;
                                            isSelectDopplerUltrasoundReport =
                                                isSelectAll;

                                            setState(() {});
                                          },
                                          selectedDocuments: selectedItems,
                                          isSelectedDoc:
                                              isSelectDopplerUltrasoundReport,
                                          documentTitle: doc['doc_title'],
                                          time: doc['timeline_time'],
                                        )),
                                      ],
                                    )
                                ],
                              ),
                            )
                          : Lottie.network(
                              'https://assets3.lottiefiles.com/packages/lf20_aBYmBC.json'),
                      otherDocs.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: defaultPadding),
                              child: Column(
                                children: [
                                  otherDocs.isNotEmpty
                                      ? Row(
                                          children: [
                                            Checkbox(
                                              checkColor: Colors.white,
                                              activeColor:
                                                  PalleteColor.primaryPurple,
                                              value: isSelectOthers,
                                              shape: const CircleBorder(),
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  isSelectOthers = value!;

                                                  if (value == true) {
                                                    setState(() {
                                                      for (var item
                                                          in otherDocs) {
                                                        selectedItems.add(
                                                            item["doc_id"]);
                                                      }
                                                    });
                                                  } else {
                                                    for (var item
                                                        in otherDocs) {
                                                      selectedItems.remove(
                                                          item['doc_id']);
                                                    }
                                                  }
                                                });
                                              },
                                            ),
                                            const Text(
                                              'Select All',
                                              style: TextStyle(
                                                  color: PalleteColor
                                                      .primaryPurple),
                                            )
                                          ],
                                        )
                                      : Container(),
                                  for (var doc in otherDocs)
                                    Column(
                                      children: [
                                        const SizedBox(height: 10),
                                        GestureDetector(
                                          child: IndividualDoc(
                                            docData: doc,
                                            documentID: doc['doc_id'],
                                            callback: (val, isSelectAll) {
                                              selectedItems = val;
                                              isSelectOthers = isSelectAll;
                                              setState(() {});
                                            },
                                            selectedDocuments: selectedItems,
                                            isSelectedDoc: isSelectOthers,
                                            documentTitle: doc['doc_title'],
                                            time: doc['timeline_time'],
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            )
                          : Lottie.network(
                              'https://assets3.lottiefiles.com/packages/lf20_aBYmBC.json'),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: const Color.fromARGB(255, 245, 246, 254),
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
                  InkWell(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.download,
                          color: PalleteColor.primaryPurple,
                        ),
                        Text('Download')
                      ],
                    ),
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
