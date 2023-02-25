import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interrupt/provider/memory_provider.dart';
import 'package:interrupt/screens/memories_upload.dart';
import 'package:provider/provider.dart';

import '../config/UI_constraints.dart';
import '../config/color_pallete.dart';

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
    print(allUserMemories);
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: PalleteColor.primaryPurple,
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => const MemoriesUpload()),
              );
            },
            child: const Icon(Icons.add)),
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
                  children: const [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Memories',
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: ListView.builder(
                      itemCount: allUserMemories.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final memory = allUserMemories[index];
                        // final formattedTime =
                        //     format12hourTime(memory['timeline_time']);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                memory['timeline_time'],
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: PalleteColor.primaryPurple),
                                  color:
                                      const Color.fromARGB(255, 231, 231, 255),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 2,
                                          color: PalleteColor.primaryPurple,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Image.network(
                                        memory['doc_url'],
                                        width: 83,
                                        height: 64,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      memory['doc_title'],
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
