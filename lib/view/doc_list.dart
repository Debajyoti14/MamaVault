import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/model/document_model.dart';
import 'package:interrupt/repository/shareDoc_repository.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/view/share.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../view_model/expire_provider.dart';
import '../view_model/user_provider.dart';
import '../resources/components/custom_text_field.dart';
import '../resources/components/primary_button.dart';
import '../resources/components/primary_icon_button.dart';
import 'individual_doc.dart';

class DocListScreen extends StatefulWidget {
  const DocListScreen({super.key});

  @override
  State<DocListScreen> createState() => _DocListScreenState();
}

class _DocListScreenState extends State<DocListScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSelectAll = false;
  bool isSelectAllUSG = false;
  bool isSelectNonStressThings = false;
  bool isSelectContractionStressThings = false;
  bool isSelectDopplerUltrasoundReport = false;
  bool isSelectOthers = false;
  ShareDocrepository shareDocRepository = ShareDocrepository();

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

  List<String> selectedItems = [];
  final expireTimeController = TextEditingController();
  bool shareProfile = true;
  final user = FirebaseAuth.instance.currentUser!;
  List allExpireLinks = [];
  final success = const SnackBar(
    content: Text('Copied to clipboard'),
  );

  Future<dynamic> fetchExpire() async {
    ExpireProvider userProvider = Provider.of(context, listen: false);
    await userProvider.fetchExpiryDetails();
  }

  Future<dynamic> fetExpireDetails() async {
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
    final allUserDocs = Provider.of<UserProvider>(context).getUserDocs;

    BuildContext modalContext = context;

    List<DocumentModel> generateCategorisedList(String docType) {
      return allUserDocs.where((element) {
        if (element.docType == docType) {
          return true;
        } else {
          return false;
        }
      }).toList();
    }

    final usgDocs = generateCategorisedList("USG Report");
    final nonStressTestDocs = generateCategorisedList("Non-Stress Test");
    final contractionStressTestDocs =
        generateCategorisedList('Contraction Stress Test');
    final dopplerUltraSoundReportDocs =
        generateCategorisedList('Doppler Ultrasound Report');
    final otherDocs = generateCategorisedList('Others');

    Widget selectDocType(List<DocumentModel> documents) {
      return documents.isNotEmpty
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  documents.isNotEmpty
                      ? Row(
                          children: [
                            Checkbox(
                              checkColor: Colors.white,
                              activeColor: AppColors.primaryPurple,
                              value: isSelectAll,
                              shape: const CircleBorder(),
                              onChanged: (bool? value) {
                                setState(() {
                                  isSelectAll = value!;

                                  if (value == true) {
                                    selectedItems.clear();
                                    setState(() {
                                      for (var item in documents) {
                                        selectedItems.add(item.docId);
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
                              style: TextStyle(color: AppColors.primaryPurple),
                            )
                          ],
                        )
                      : Container(),
                  for (var doc in documents)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: defaultPadding,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 10.h),
                          GestureDetector(
                              child: IndividualDoc(
                            docData: doc,
                            documentID: doc.docId,
                            callback: (val, isSelectAllfr) {
                              selectedItems = val;
                              isSelectAll = isSelectAllfr;
                              setState(() {});
                            },
                            selectedDocuments: selectedItems,
                            isSelectedDoc: isSelectAll,
                            documentTitle: doc.docTitle,
                            time: doc.timelineTime,
                          )),
                        ],
                      ),
                    )
                ],
              ),
            )
          : Lottie.network(
              'https://assets3.lottiefiles.com/packages/lf20_aBYmBC.json');
    }

    return DefaultTabController(
      length: docCategoriesTabs.length,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          elevation: 0,
          backgroundColor: AppColors.bodyTextColorLight,
          bottom: TabBar(
            indicatorColor: AppColors.primaryPurple,
            labelStyle: TextStyle(
              fontSize: 24.0.sp,
              fontWeight: FontWeight.bold,
              fontFamily:
                  GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14.0.sp,
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
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width,
                  child: TabBarView(
                    children: [
                      selectDocType(allUserDocs),
                      selectDocType(usgDocs),
                      selectDocType(nonStressTestDocs),
                      selectDocType(contractionStressTestDocs),
                      selectDocType(dopplerUltraSoundReportDocs),
                      selectDocType(otherDocs),
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
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter myState) {
                              return BottomSheet(
                                onClosing: () {},
                                builder: (BuildContext context) {
                                  return SizedBox(
                                    height: 350.h +
                                        MediaQuery.of(context)
                                            .viewInsets
                                            .bottom,
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: defaultPadding,
                                          right: defaultPadding,
                                          bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            Text(
                                              'Expiry Time',
                                              style: TextStyle(
                                                fontSize: 18.sp,
                                                fontFamily: GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.bold)
                                                    .fontFamily,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Form(
                                              key: _formKey,
                                              child: CustomTextField(
                                                isNumber: true,
                                                hintText:
                                                    "Enter Expiry time in hrs",
                                                controller:
                                                    expireTimeController,
                                                validator: (value) {
                                                  if (value
                                                      .toString()
                                                      .isEmpty) {
                                                    return 'Time Required';
                                                  } else if (int.parse(value) /
                                                          24 >
                                                      30) {
                                                    return 'Maximum Limit 30 days';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20.h,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Share Profile",
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontFamily:
                                                        GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)
                                                            .fontFamily,
                                                  ),
                                                ),
                                                StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter
                                                            stateSetter) {
                                                  return Switch(
                                                    value: shareProfile,
                                                    activeColor:
                                                        AppColors.primaryPurple,
                                                    onChanged: (val) {
                                                      stateSetter(() =>
                                                          shareProfile = val);
                                                    },
                                                  );
                                                }),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 50.h,
                                            ),
                                            PrimaryIconButton(
                                              buttonTitle: "Next",
                                              buttonIcon: FaIcon(
                                                FontAwesomeIcons.link,
                                                size: 18.w,
                                              ),
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  Map<String, dynamic> data = {
                                                    "uid": user.uid, // user id
                                                    "isprofile":
                                                        shareProfile, // shares profile
                                                    "ttl": int.parse(
                                                            expireTimeController
                                                                .text) *
                                                        3600, //in seconds
                                                    "shared_docs":
                                                        selectedItems,
                                                  };
                                                  Navigator.pop(context);
                                                  var res =
                                                      await shareDocRepository
                                                          .getSharableLink(
                                                              data);

                                                  fetchExpire();
                                                  if (mounted) {
                                                    showModalBottomSheet(
                                                        context: modalContext,
                                                        builder: (BuildContext
                                                            context) {
                                                          return SizedBox(
                                                            height: 500.h,
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          defaultPadding),
                                                              child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      height:
                                                                          40.h,
                                                                    ),
                                                                    Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        border:
                                                                            Border.all(
                                                                          color: const Color.fromARGB(
                                                                              255,
                                                                              224,
                                                                              223,
                                                                              223),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          QrImageView(
                                                                        data: res[
                                                                            'share_doc_link'],
                                                                        size: 200
                                                                            .h,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        height:
                                                                            30.h),
                                                                    Container(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                8),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          border:
                                                                              Border.all(
                                                                            color: const Color.fromARGB(
                                                                                255,
                                                                                224,
                                                                                223,
                                                                                223),
                                                                          ),
                                                                        ),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            SizedBox(
                                                                              width: 300.w,
                                                                              child: Text(res['share_doc_link']),
                                                                            ),
                                                                            InkWell(
                                                                              child: const Icon(Icons.copy),
                                                                              onTap: () {
                                                                                FlutterClipboard.copy(res['share_doc_link']).then(
                                                                                  (value) => ScaffoldMessenger.of(context).showSnackBar(success),
                                                                                );
                                                                                Navigator.pop(context);
                                                                              },
                                                                            )
                                                                          ],
                                                                        )),
                                                                    SizedBox(
                                                                      height:
                                                                          20.h,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        SizedBox(
                                                                          width:
                                                                              153.w,
                                                                          height:
                                                                              60.h,
                                                                          child:
                                                                              ElevatedButton.icon(
                                                                            onPressed:
                                                                                null,
                                                                            icon:
                                                                                const Icon(Icons.send, color: AppColors.primaryPurple),
                                                                            label:
                                                                                const Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: 8),
                                                                              child: Text(
                                                                                'Send Via Email',
                                                                                style: TextStyle(color: AppColors.primaryPurple),
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                            style:
                                                                                ElevatedButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(12.0),
                                                                              ),
                                                                              backgroundColor: AppColors.bodyTextColorLight,
                                                                              textStyle: TextStyle(
                                                                                fontFamily: GoogleFonts.poppins().fontFamily,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontSize: 16.sp,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                20.w),
                                                                        SizedBox(
                                                                          width:
                                                                              153.w,
                                                                          child: PrimaryButton(
                                                                              buttonTitle: 'View Shared Links',
                                                                              onPressed: () {
                                                                                Navigator.push(context, CupertinoPageRoute(builder: (_) => const Share()));
                                                                              }),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ]),
                                                            ),
                                                          );
                                                        });
                                                  }
                                                }
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
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.share,
                          color: AppColors.primaryPurple,
                        ),
                        Text('Share')
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.download,
                          color: AppColors.primaryPurple,
                        ),
                        Text('Download')
                      ],
                    ),
                  ),
                  // TODO Delete Share Doc
                  InkWell(
                    onTap: () async {
                      // for (var item in selectedItems) {
                      //   shareDocRepository.deleteSharedDoc(item, user.uid);
                      // }
                    },
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        Text('Delete')
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
