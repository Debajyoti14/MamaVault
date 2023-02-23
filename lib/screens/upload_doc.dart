import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io' as io;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/config/color_pallete.dart';
import 'package:interrupt/widgets/custom_text_field.dart';
import 'package:interrupt/widgets/primary_button.dart';
import 'package:interrupt/widgets/primary_icon_button.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadDoc extends StatefulWidget {
  const UploadDoc({super.key});

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  List uploadedImageURL = [];
  final ImagePicker imagePicker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser!;
  final docTitle = TextEditingController();
  List<XFile> imageFileList = [];
  List<XFile> currentImages = [];
  List<String> fileTitle = [];
  List<String> allTitleList = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isSelected = true;
  late String displayImageUrl = "assets/imageUploadIcon.png";
  int nameIndex = 0;
  late String docType;

  Future openPicker() async {
    List<XFile> currentImage = await imagePicker.pickMultiImage();
    if (currentImage.isNotEmpty) {
      currentImages.addAll(currentImage);
      setState(() {
        isSelected = false;
      });
    }
  }

  void selectImages() {
    docTitle.clear();
    setState(() {
      imageFileList.addAll(currentImages);
      currentImages = [];
      isSelected = true;
    });
    Navigator.pop(context);
  }

  Future uploadFile() async {
    imageFileList.forEach((image) async {
      nameIndex++;
      final finalFile = File(image.path);
      final storageRef = FirebaseStorage.instance.ref();
      final uploadTask = await storageRef
          .child("${user.uid}/documents/${image.name}")
          .putFile(finalFile);
      var dowurl = await uploadTask.ref.getDownloadURL();
      var meta = await uploadTask.ref.getMetadata();
      await addDocDetails(dowurl, meta.contentType);
    });
  }

  Future addDocDetails(String imageURL, String? metaData) async {
    final user = FirebaseAuth.instance.currentUser!;

    final finalUser = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('documents')
        .doc();
    final data = {
      'doc_url': imageURL,
      'doc_type': docType,
      'doc_title': fileTitle[nameIndex],
      'doc_format': metaData,
      "doc_download_url": imageURL,
      "upload_time": "",
      "timeline_time": ""
    };
    await finalUser.set(data);
  }

  Future checkTitle() async {
    final CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('users/${user.uid}/documents');
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    allData.forEach((data) {
      allTitleList.add(data['doc_type']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              "Upload Document",
              style: TextStyle(
                fontSize: 32,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
              ),
            ),
            const SizedBox(
              height: 30,
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
              (imageFileList.length < 3)
                  ? IconButton(
                      color: PalleteColor.primaryPurple,
                      icon: const Icon(Icons.add_a_photo),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return bottomSheet();
                              });
                            });
                      },
                    )
                  : const Text('Max 3 Images!'),
            ]),
            const SizedBox(
              height: 20,
            ),
            (imageFileList.isNotEmpty)
                ? GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: imageFileList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, crossAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: 80,
                            child: Image.file(
                              io.File(imageFileList[index].path),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(fileTitle[index]),
                        ],
                      );
                    },
                  )
                : Container(),
            const SizedBox(height: 200),
            PrimaryButton(
              buttonTitle: "Upload",
              onPressed: () async {
                await uploadFile();
                nameIndex = 0;
              },
            ),
          ],
        )),
      ),
    );
  }

  SizedBox bottomSheet() {
    return SizedBox(
      height: 700,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: defaultPadding,
              right: defaultPadding,
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                'Choose Image',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              (isSelected)
                  ? InkWell(
                      onTap: () async {
                        await openPicker();
                        await checkTitle();
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
                        child: Image.asset(displayImageUrl),
                      ),
                    )
                  : Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 224, 223, 223),
                        ),
                      ),
                      child: Image.file(
                        io.File(currentImages[0].path),
                        fit: BoxFit.contain,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: CustomTextField(
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
                height: 10,
              ),
              PrimaryIconButton(
                buttonTitle: "Next",
                buttonIcon: const FaIcon(FontAwesomeIcons.image),
                onPressed: () async {
                  await checkTitle();
                  if (formKey.currentState!.validate()) {
                    fileTitle.add(docTitle.text);
                    selectImages();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
