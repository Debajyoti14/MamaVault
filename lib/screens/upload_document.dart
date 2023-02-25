import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/widgets/primary_button.dart';

import '../config/color_pallete.dart';
import '../widgets/custom_text_field.dart';

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({super.key});

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  List<File?> fileList = [];
  int nameIndex = 0;
  List uploadedImageURL = [];
  late String docType;

  File? file;
  bool isSelected = true;
  late String fileExt;
  List<File?> currentFiles = [];

  List<String> allTitleList = [];
  final user = FirebaseAuth.instance.currentUser!;
  final docTitle = TextEditingController();
  final dateController = TextEditingController();

  Future openPicker() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    file = File(path);
    currentFiles.add(file);

    PlatformFile fileDetails = result.files.first;
    setState(() {
      debugPrint("InSetState");
      fileList.add(file);
      isSelected = false;
      fileExt = fileDetails.extension!;
    });
  }

  Future uploadFile() async {
    fileList.forEach((image) async {
      var fileName = docTitle.text;

      final finalFile = File(image!.path);
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask = await storageRef
          .child("${user.uid}/documents/$fileName")
          .putFile(finalFile);
      var dowurl = await uploadTask.ref.getDownloadURL();
      var meta = await uploadTask.ref.getMetadata();
      await addDocDetails(dowurl, meta.contentType);
      nameIndex++;
    });
  }

  Future addDocDetails(String imageURL, String? metaData) async {
    final user = FirebaseAuth.instance.currentUser!;

    final finalUser = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('documents');
    final data = {
      'doc_url': imageURL,
      'doc_type': docType,
      'doc_title':
          (fileList.length > 1) ? "${docTitle.text}$nameIndex" : docTitle.text,
      'doc_format': metaData,
      "doc_download_url": imageURL,
      "upload_time": dateController.text,
      "timeline_time": dateController.text,
    };
    await finalUser.add(data).then((value) {
      String docId = value.id;
      finalUser.doc(docId).update({'doc_id': docId});
    });
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
                'Upload Document',
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.bold)
                              .fontFamily,
                    ),
                  ),
                  Text(
                    'Minimum 1 Image required',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500)
                              .fontFamily,
                    ),
                  ),
                ],
              ),
              (currentFiles.length < 3)
                  ? IconButton(
                      color: PalleteColor.primaryPurple,
                      icon: const Icon(Icons.add_a_photo),
                      onPressed: () {
                        openPicker();
                      },
                    )
                  : const Text('Max 3 Images!'),
            ]),
            const SizedBox(
              height: 20,
            ),
            (fileList.isNotEmpty)
                ? GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: fileList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, crossAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: const [
                          SizedBox(
                            height: 60,
                            child: Icon(
                              Icons.edit_document,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Data"),
                        ],
                      );
                    },
                  )
                : Container(
                    height: 140,
                  ),
            const SizedBox(height: 60),
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
              // controller: dateController,
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
              height: 10,
            ),
            CustomTextField(
              height: 20,
              hintText: "Enter Title",
              controller: docTitle,
              validator: (value) {
                if (value.toString().isEmpty) {
                  return 'Title Required';
                } else if (allTitleList.contains(value.toString())) {
                  return 'File name already exists';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Doc Type'),
                isExpanded: true,
                items: <String>[
                  'USG Report',
                  'Non-Stress Test',
                  'Contraction Stress Test',
                  'Doppler Ultrasound Report',
                  'Others'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  docType = value!;
                },
                validator: (value) {
                  if (docType == '') {
                    return 'Doc type is required';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 120,
            ),
            PrimaryButton(
                buttonTitle: "Upload",
                onPressed: () async {
                  await uploadFile();
                  nameIndex = 0;
                })
          ],
        )),
      ),
    );
  }
}
