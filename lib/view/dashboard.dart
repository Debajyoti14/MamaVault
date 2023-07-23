import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/data/response/status.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/view_model/dashboard_view_model.dart';
import 'package:interrupt/view_model/user_provider.dart';
import 'package:interrupt/view/Panic%20Mode/panic_mode_timer.dart';
import 'package:interrupt/view/profile.dart';
import 'package:interrupt/view/upload_document.dart';
import 'package:interrupt/resources/components/primary_icon_button.dart';
import 'package:provider/provider.dart';

import '../resources/UI_constraints.dart';
import '../utils/date_formatter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  DashboardViewModel dashboardViewModel = DashboardViewModel();

  @override
  Widget build(BuildContext context) {
    List allUserDocs = Provider.of<UserProvider>(context).getUserDocs;
    dashboardViewModel.getTimeline(allUserDocs.toString());
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 32.sp,
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
                        backgroundColor: AppColors.primaryPurple,
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
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.all(16.0.w),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 235, 233),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  height: 104.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Panic Button',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.sp),
                          ),
                          SizedBox(
                            width: 153.w,
                            child: Text(
                              'Panic Button is made for emergency situation so be careful',
                              style: TextStyle(fontSize: 10.sp),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 136.w,
                        height: 50.h,
                        child: PrimaryIconButton(
                          backgroundColor: Colors.red,
                          buttonTitle: 'Panic',
                          buttonIcon: const FaIcon(FontAwesomeIcons.bell),
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const PanicModeScreen(),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: ChangeNotifierProvider<DashboardViewModel>(
                      create: (BuildContext context) => dashboardViewModel,
                      child: Consumer<DashboardViewModel>(
                        builder: (context, value, child) {
                          switch (value.timeline.status) {
                            case Status.LOADING:
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryPurple,
                                ),
                              );
                            case Status.ERROR:
                              print("=======================");
                              return Center(
                                child: Text(value.timeline.message.toString()),
                              );
                            case Status.COMPLETED:
                              print(value.timeline.data?.length.runtimeType);
                              print("=======================");
                              return ListView.builder(
                                itemCount: value.timeline.data?.length ?? 0,
                                itemBuilder: (BuildContext context, int index) {
                                  final singletimeline =
                                      value.timeline.data?[index];
                                  final formattedTime =
                                      format12hourTime(singletimeline['time']);
                                  return value.timeline.data.length > 0
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          width: size.width,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                formattedTime,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily:
                                                      GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                  ).fontFamily,
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: AppColors
                                                          .primaryPurple),
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
                                                                          const EdgeInsets.all(
                                                                              5),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        border:
                                                                            Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              AppColors.primaryPurple,
                                                                        ),
                                                                        borderRadius:
                                                                            const BorderRadius.all(
                                                                          Radius.circular(
                                                                              10),
                                                                        ),
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        doc['doc_url'],
                                                                        width:
                                                                            83,
                                                                        height:
                                                                            64,
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            const BorderRadius.all(
                                                                          Radius.circular(
                                                                              10),
                                                                        ),
                                                                        border:
                                                                            Border.all(
                                                                          width:
                                                                              2,
                                                                          color:
                                                                              AppColors.primaryPurple,
                                                                        ),
                                                                      ),
                                                                      child: Image
                                                                          .network(
                                                                        'https://www.woschool.com/wp-content/uploads/2020/09/png-transparent-pdf-icon-illustration-adobe-acrobat-portable-document-format-computer-icons-adobe-reader-file-pdf-icon-miscellaneous-text-logo.png',
                                                                        width:
                                                                            93,
                                                                        height:
                                                                            64,
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
                                        )
                                      : const SizedBox();
                                },
                              );
                            default:
                              return Container();
                          }
                        },
                      ),
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
          backgroundColor: AppColors.primaryPurple,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
