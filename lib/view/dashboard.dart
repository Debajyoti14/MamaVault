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
import '../resources/components/shimmer_list.dart';
import '../utils/date_formatter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;
  DashboardViewModel dashboardViewModel = DashboardViewModel();

  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _topAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
        tween:
            Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _bottomAlignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomRight, end: Alignment.bottomLeft),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.bottomLeft, end: Alignment.topLeft),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween:
            Tween<Alignment>(begin: Alignment.topLeft, end: Alignment.topRight),
        weight: 1,
      ),
      TweenSequenceItem<Alignment>(
        tween: Tween<Alignment>(
            begin: Alignment.topRight, end: Alignment.bottomRight),
        weight: 1,
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allUserDocs =
        Provider.of<UserProvider>(context, listen: false).getUserDocs;
    dashboardViewModel.getTimeline(allUserDocs);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
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
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ChangeNotifierProvider<DashboardViewModel>(
                    create: (BuildContext context) => dashboardViewModel,
                    child: Consumer<DashboardViewModel>(
                      builder: (context, value, child) {
                        switch (value.timeline.status) {
                          case Status.LOADING:
                            return const ShimmerList(
                              length: 3,
                              padding: EdgeInsets.symmetric(vertical: 20),
                            );
                          case Status.ERROR:
                            return Center(
                              child: Text(value.timeline.message.toString()),
                            );
                          case Status.COMPLETED:
                            return value.timeline.data.length > 0
                                ? Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        width: 5,
                                        height: size.height,
                                        color: AppColors.primaryPurple,
                                      ),
                                      SizedBox(width: size.width * 0.05),
                                      SizedBox(
                                        width: size.width * 0.835,
                                        child: ListView.builder(
                                          itemCount:
                                              value.timeline.data?.length ?? 0,
                                          shrinkWrap: true,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final singletimeline =
                                                value.timeline.data?[index];
                                            final formattedTime =
                                                format12hourTime(
                                                    singletimeline['time']);
                                            return Container(
                                              padding: const EdgeInsets.only(
                                                bottom: 12.0,
                                              ),
                                              width: size.width,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    formattedTime,
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ).fontFamily,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  AnimatedBuilder(
                                                    animation: _controller,
                                                    builder: (context, _) {
                                                      return Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(16.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              AppColors
                                                                  .primaryPurple
                                                                  .withOpacity(
                                                                      0.2),
                                                              Colors.white,
                                                            ],
                                                            begin:
                                                                _topAlignmentAnimation
                                                                    .value,
                                                            end:
                                                                _bottomAlignmentAnimation
                                                                    .value,
                                                          ),
                                                          // border: Border.all(
                                                          //     width: 2,
                                                          //     color: AppColors
                                                          //         .primaryPurple),
                                                          // color:
                                                          //     const Color.fromARGB(
                                                          //         255,
                                                          //         231,
                                                          //         231,
                                                          //         255),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          8)),
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Text(
                                                              'Document Attached',
                                                              style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            const SizedBox(
                                                                height: 15),
                                                            Row(
                                                              children: [
                                                                for (var doc
                                                                    in singletimeline[
                                                                        'document'])
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        (doc['doc_format'] == 'image/jpeg' ||
                                                                                doc['doc_format'] == 'image/png')
                                                                            ? Container(
                                                                                decoration: BoxDecoration(
                                                                                  border: Border.all(
                                                                                    width: 2,
                                                                                    color: AppColors.primaryPurple,
                                                                                  ),
                                                                                  borderRadius: const BorderRadius.all(
                                                                                    Radius.circular(10),
                                                                                  ),
                                                                                ),
                                                                                child: ClipRRect(
                                                                                  borderRadius: const BorderRadius.all(
                                                                                    Radius.circular(10),
                                                                                  ),
                                                                                  child: Image.network(doc['doc_url'], width: 83, height: 64, fit: BoxFit.fill),
                                                                                ),
                                                                              )
                                                                            : Container(
                                                                                padding: const EdgeInsets.all(8),
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius: const BorderRadius.all(
                                                                                    Radius.circular(10),
                                                                                  ),
                                                                                  border: Border.all(
                                                                                    width: 2,
                                                                                    color: AppColors.primaryPurple,
                                                                                  ),
                                                                                ),
                                                                                child: Image.network(
                                                                                  'https://www.iconpacks.net/icons/2/free-pdf-icon-1512-thumb.png',
                                                                                  width: 93,
                                                                                  height: 64,
                                                                                ),
                                                                              ),
                                                                        const SizedBox(
                                                                            height:
                                                                                5),
                                                                        Text(
                                                                          doc['doc_title'],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: Text("No Documents Uploaded"),
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
    );
  }
}
