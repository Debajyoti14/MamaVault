import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/utils/date_formatter.dart';
import 'package:interrupt/view_model/memory_provider.dart';
import 'package:interrupt/view/memories_upload.dart';
import 'package:provider/provider.dart';

import '../resources/UI_constraints.dart';

class MemoryTimeline extends StatefulWidget {
  const MemoryTimeline({super.key});

  @override
  State<MemoryTimeline> createState() => _MemoryTimelineState();
}

class _MemoryTimelineState extends State<MemoryTimeline>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser!;

  late AnimationController _controller;
  late Animation<Alignment> _topAlignmentAnimation;
  late Animation<Alignment> _bottomAlignmentAnimation;

  double scaleFactor = 1;
  bool isVisible = true;
  fetchMemories() async {
    MemoryProvider memoryProvider = Provider.of(context, listen: false);
    await memoryProvider.fetchUserMemories();
  }

  @override
  void initState() {
    super.initState();
    fetchMemories();
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
    List allUserMemories = Provider.of<MemoryProvider>(context).getUserMemories;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      floatingActionButton: Transform.scale(
        scale: scaleFactor,
        child: FloatingActionButton(
          backgroundColor: AppColors.primaryPurple,
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Memories',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: allUserMemories.isNotEmpty
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              width: 5,
                              height: size.height,
                              color: AppColors.primaryPurple,
                            ),
                            SizedBox(width: size.width * 0.05),
                            SizedBox(
                              width: size.width * 0.835,
                              child: ListView.builder(
                                itemCount: allUserMemories.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final memory = allUserMemories[index];
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          viableDateString(
                                              memory['timeline_time']),
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 10.h),
                                        AnimatedBuilder(
                                          animation: _controller,
                                          builder: (context, _) {
                                            return Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    AppColors.primaryPurple
                                                        .withOpacity(0.2),
                                                    Colors.white,
                                                  ],
                                                  begin: _topAlignmentAnimation
                                                      .value,
                                                  end: _bottomAlignmentAnimation
                                                      .value,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(8)),
                                              ),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        width: 2,
                                                        color: AppColors
                                                            .primaryPurple,
                                                      ),
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(10),
                                                      ),
                                                      child: Image.network(
                                                        memory['doc_url'],
                                                        width: 83.w,
                                                        height: 64.h,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 15.w),
                                                  Text(
                                                    memory['doc_title'],
                                                    style: TextStyle(
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
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
                      : const Center(child: Text("No Memories so far...")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  scale() async {
    setState(() {
      isVisible = true;
    });
    for (var i = 0; i < 200; i++) {
      await Future.delayed(const Duration(milliseconds: 4), () {
        setState(() {
          scaleFactor += 0.15;
        });
      });
    }
    if (context.mounted) {
      Navigator.of(context)
          .push(CupertinoPageRoute(
        builder: (context) => const MemoriesUpload(),
      ))
          .then((value) async {
        for (var i = 0; i < 200; i++) {
          await Future.delayed(const Duration(milliseconds: 4), () {
            setState(() {
              scaleFactor -= 0.15;
            });
          });
        }
        setState(() {
          isVisible = true;
        });
      });
    }
  }

  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MemoriesUpload(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const curve = Curves.fastEaseInToSlowEaseOut;
          final curvedAnimation =
              CurvedAnimation(parent: animation, curve: curve);
          return ScaleTransition(
            scale: curvedAnimation,
            child: child,
          );
        });
  }
}
