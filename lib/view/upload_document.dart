import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/utils/date_formatter.dart';
import 'package:interrupt/resources/components/primary_button.dart';
import 'package:provider/provider.dart';

import '../view_model/user_provider.dart';
import '../resources/components/custom_text_field.dart';

class DocumentUpload extends StatefulWidget {
  const DocumentUpload({super.key});

  @override
  State<DocumentUpload> createState() => _DocumentUploadState();
}

class _DocumentUploadState extends State<DocumentUpload> {
  final storageRef = FirebaseStorage.instance.ref();

  List<File?> fileList = [];
  int nameIndex = 0;
  List uploadedImageURL = [];
  String docType = '';

  List<File> files = [];
  bool isSelected = true;
  bool isLoading = false;
  late String fileExt;
  List<File?> currentFiles = [];
  DateTime? _selectedDate;

  List<String> allTitleList = [];
  final user = FirebaseAuth.instance.currentUser!;
  final docTitle = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future openPicker() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    }

    PlatformFile fileDetails = result!.files.first;
    setState(() {
      debugPrint("InSetState");
      fileList = files;
      isSelected = false;
      fileExt = fileDetails.extension!;
      print(fileExt);
    });
  }

  Future uploadFile(File? image) async {
    isLoading = true;
    setState(() {});
    var fileName = docTitle.text;

    final finalFile = File(image!.path);
    final uploadTask = await storageRef
        .child("${user.uid}/documents/$fileName$nameIndex")
        .putFile(finalFile);

    var dowurl = await uploadTask.ref.getDownloadURL();

    var meta = await uploadTask.ref.getMetadata();
    await addDocDetails(dowurl, meta.contentType);

    nameIndex++;
  }

  fetchDocs() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.fetchUserDocs();
    isLoading = false;
    setState(() {});
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
      "upload_time": _selectedDate,
      "timeline_time": _selectedDate,
    };
    await finalUser.add(data).then((value) {
      String docId = value.id;
      finalUser.doc(docId).update({'doc_id': docId});
    });
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.primaryPurple),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Upload Document',
                    style: TextStyle(
                      fontSize: 32,
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.bold)
                              .fontFamily,
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Documents',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold)
                                  .fontFamily,
                            ),
                          ),
                          Text(
                            'Minimum 1 Document required',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500)
                                  .fontFamily,
                            ),
                          ),
                        ],
                      ),
                      (fileList.isEmpty)
                          ? IconButton(
                              color: AppColors.primaryPurple,
                              icon: const Icon(Icons.add_a_photo),
                              onPressed: () async {
                                openPicker();
                                await checkTitle();
                              },
                            )
                          : Container(),
                    ]),
                const SizedBox(
                  height: 20,
                ),
                (fileList.isNotEmpty)
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: fileList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: AppColors.primaryPurple),
                              color: const Color.fromARGB(255, 231, 231, 255),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: ListTile(
                              leading: const FaIcon(
                                FontAwesomeIcons.file,
                                color: AppColors.primaryPurple,
                              ),
                              title: Text(fileList[index]!.path.split("/").last,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 140,
                      ),
                const SizedBox(height: 30),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Choose Date"),
                ),
                const SizedBox(
                  height: 5,
                ),
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
                      print(docType);
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
                  height: 60,
                ),
                PrimaryButton(
                    buttonTitle: "Upload",
                    isLoading: isLoading,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        for (var file in fileList) {
                          await uploadFile(file);
                        }
                        await fetchDocs();
                        // dateController.clear();
                        // docTitle.clear();
                        // nameIndex = 0;
                        // docType = '';
                        // fileList = [];
                        // setState(() {});
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
