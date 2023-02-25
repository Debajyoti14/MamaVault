import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/widgets/primary_button.dart';

import '../widgets/custom_text_field.dart';

class MemoriesUpload extends StatefulWidget {
  const MemoriesUpload({super.key});

  @override
  State<MemoriesUpload> createState() => _MemoriesUploadState();
}

class _MemoriesUploadState extends State<MemoriesUpload> {
  late final XFile? image;
  bool isLoading = true;
  final user = FirebaseAuth.instance.currentUser!;
  final docTitle = TextEditingController();
  final dateController = TextEditingController();
  var counter = 0;
  Future openPicker() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      counter++;
    });
  }

  Future uploadImage() async {
    final finalFile = File(image!.path);
    final fileName = image!.name;
    final storageRef = FirebaseStorage.instance.ref();
    final uploadTask = await storageRef
        .child("${user.uid}/memories/$fileName")
        .putFile(finalFile);
    var dowurl = await uploadTask.ref.getDownloadURL();
    await addDocDetails(dowurl);
    setState(() {
      counter = 0;
      isLoading = false;
    });
  }

  Future addDocDetails(String imageURL) async {
    final finalUser = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('memories');
    final data = {
      'doc_url': imageURL,
      'doc_title': docTitle.text,
      "upload_time": dateController.text,
      "timeline_time": dateController.text,
    };
    await finalUser.add(data).then((value) {
      String docId = value.id;
      finalUser.doc(docId).update({'doc_id': docId});
    });
  }

  Future showDone() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text('Memory uploaded sucessfully'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upload Memories',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                        .fontFamily,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              counter == 0
                  ? InkWell(
                      onTap: () async {
                        await openPicker();
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color.fromARGB(255, 224, 223, 223),
                          ),
                        ),
                        child: Image.asset("assets/imageUploadIcon.png"),
                      ),
                    )
                  : Image.file(
                      io.File(image!.path),
                      fit: BoxFit.cover,
                    ),
              const SizedBox(height: 60),
              const SizedBox(
                height: 5,
              ),
              CustomTextField(
                height: 20,
                hintText: "Enter Title",
                controller: docTitle,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Title Required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text("Choose Date"),
              ),
              const SizedBox(
                height: 5,
              ),
              DateTimePicker(
                dateHintText: 'Select Date',
                calendarTitle: 'MamaVault',
                type: DateTimePickerType.date,
                controller: dateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                onChanged: (val) {},
                onSaved: (val) {},
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Date is required';
                  } else {
                    return null;
                  }
                },
              ),
              const SizedBox(
                height: 80,
              ),
              PrimaryButton(
                  buttonTitle: "Upload",
                  onPressed: () async {
                    await uploadImage();
                    if (mounted) {
                      showDone();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
