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

class _MemoryTimelineState extends State<MemoryTimeline> {
  final user = FirebaseAuth.instance.currentUser!;
  fetchMemories() async {
    MemoryProvider memoryProvider = Provider.of(context, listen: false);
    await memoryProvider.fetchUserMemories();
  }

  @override
  void initState() {
    fetchMemories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List allUserMemories = Provider.of<MemoryProvider>(context).getUserMemories;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primaryPurple,
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(builder: (_) => const MemoriesUpload()),
            );
          },
          child: const Icon(Icons.add)),
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
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: AppColors.primaryPurple),
                                            color: const Color.fromARGB(
                                                255, 231, 231, 255),
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
                                                    color:
                                                        AppColors.primaryPurple,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.all(
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
}
