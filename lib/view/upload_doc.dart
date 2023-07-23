import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/utils/date_formatter.dart';
import 'package:interrupt/resources/components/custom_text_field.dart';
import 'package:interrupt/resources/components/primary_button.dart';
import 'package:interrupt/resources/components/primary_icon_button.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadDoc extends StatefulWidget {
  const UploadDoc({super.key});

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List uploadedImageURL = [];
  final ImagePicker imagePicker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser!;
  final docTitle = TextEditingController();
  List<File?> imageFileList = [];
  List<File?> currentImages = [];
  List<String> fileTitle = [];
  List<String> allTitleList = [];
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isSelected = true;
  bool isLoading = false;
  late String displayImageUrl = "assets/imageUploadIcon.png";
  int nameIndex = 0;
  late String docType;
  File? file;
  late String fileExt;
  DateTime? _selectedDate;

  Future openPicker() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    final path = result.files.single.path!;
    file = File(path);
    currentImages.add(file);
    PlatformFile fileDetails = result.files.first;
    setState(() {
      imageFileList.add(file);
      isSelected = false;
      fileExt = fileDetails.extension!;
    });
  }

  void selectImages(BuildContext context) {
    docTitle.clear();
    setState(() {
      currentImages = [];
      isSelected = true;
      fileExt = "";
    });
    Navigator.pop(context);
  }

  Future uploadFile() async {
    isLoading = true;
    imageFileList.forEach((image) async {
      var fileName = fileTitle[nameIndex];
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
    isLoading = false;
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
      'doc_title': fileTitle[nameIndex],
      'doc_format': metaData,
      "doc_download_url": imageURL,
      "upload_time": _selectedDate,
      "timeline_time": _selectedDate,
    };
    await finalUser.add(data).then((value) {
      String docId = value.id;
      finalUser.doc(docId).update({'doc_id': docId});
    });
  }

  Future checkTitle() async {
    final CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users/${user.uid}/documents');
    QuerySnapshot querySnapshot = await collectionRef.get();
    final allData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    for (var data in allData) {
      allTitleList.add(data['doc_type']);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            // Customize the date picker theme properties
            primaryColor: AppColors.primaryPurple, // Customize primary color
            // Add more customizations as needed
            colorScheme: Theme.of(context)
                .colorScheme
                .copyWith(secondary: AppColors.primaryPurple),
          ),
          child: child!,
        );
      },
    );

    if (picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.primaryPurple),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload Document",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                      .fontFamily,
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
                      'Minimum 1 Document required',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                .fontFamily,
                      ),
                    ),
                  ],
                ),
                (currentImages.length < 3)
                    ? IconButton(
                        color: AppColors.primaryPurple,
                        icon: const Icon(Icons.add_a_photo),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(builder:
                                    (BuildContext context,
                                        StateSetter setState) {
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
                      itemCount: fileTitle.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, crossAxisSpacing: 10),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 80,
                              child: Text('pdf'),
                              // child: (fileExt == 'pdf')
                              //     ? const Text("Pdf")
                              //     : Image.file(
                              //         io.File(imageFileList[index]!.path),
                              //         fit: BoxFit.fitHeight,
                              //       ),
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
              const Text('Select Date'),
              GestureDetector(
                onTap: () async {
                  await _selectDate(context);
                },
                child: TextFormField(
                  validator: (value) {
                    if (_selectedDate == null) {
                      return "Select Date";
                    } else {
                      return null;
                    }
                  },
                  enabled: false,
                  decoration: InputDecoration(
                    hintText: _selectedDate != null
                        ? formatDate(_selectedDate!)
                        : 'Enter Date',
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryPurple),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              PrimaryButton(
                buttonTitle: "Upload",
                isLoading: isLoading,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await uploadFile();
                    nameIndex = 0;
                  }
                },
              ),
            ],
          ),
        )),
      ),
    );
  }

  BottomSheet bottomSheet() {
    return BottomSheet(
      onClosing: () {},
      builder: (BuildContext context) {
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
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.bold)
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
                          child: const Text("Document Selected"),
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
                        if (mounted) {
                          selectImages(context);
                        }
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
