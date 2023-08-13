import 'dart:io' as io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/utils/date_formatter.dart';
import 'package:interrupt/resources/components/primary_button.dart';
import 'package:interrupt/view_model/memory_provider.dart';
import 'package:provider/provider.dart';

import '../resources/components/custom_text_field.dart';

class MemoriesUpload extends StatefulWidget {
  const MemoriesUpload({super.key});

  @override
  State<MemoriesUpload> createState() => _MemoriesUploadState();
}

class _MemoriesUploadState extends State<MemoriesUpload> {
  XFile? image;
  bool isLoading = false;
  DateTime? _selectedDate;
  final user = FirebaseAuth.instance.currentUser!;
  final docTitle = TextEditingController();
  Future openPicker() async {
    final ImagePicker picker = ImagePicker();
    image = await picker.pickImage(source: ImageSource.gallery);
  }

  Future uploadImage() async {
    isLoading = true;
    setState(() {});
    final finalFile = File(image!.path);
    final fileName = image!.name;
    final storageRef = FirebaseStorage.instance.ref();
    final uploadTask = await storageRef
        .child("${user.uid}/memories/$fileName")
        .putFile(finalFile);
    var dowurl = await uploadTask.ref.getDownloadURL();
    await addDocDetails(dowurl);
    setState(() {
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
      "upload_time":
          formatdateTimeToStoreInFireStore(_selectedDate ?? DateTime.now()),
      "timeline_time":
          formatdateTimeToStoreInFireStore(_selectedDate ?? DateTime.now()),
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
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: AppColors.primaryPurple,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upload Memories',
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold)
                        .fontFamily,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
              (image == null)
                  ? InkWell(
                      onTap: () async {
                        await openPicker();
                      },
                      child: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.white,
                        size: 120,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        io.File(image!.path),
                        fit: BoxFit.fill,
                        width: size.width,
                        height: 200.h,
                      ),
                    ),
              SizedBox(height: 60.h),
              SizedBox(
                height: 5.h,
              ),
              CustomTextField(
                height: 20.h,
                hintText: "Enter Title",
                controller: docTitle,
                isPurple: true,
                validator: (value) {
                  if (value.toString().isEmpty) {
                    return 'Title Required';
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 20.h,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Choose Date",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 5.h,
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
                    hintStyle: const TextStyle(color: Colors.white),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 13,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80.h,
              ),
              PrimaryButton(
                  isLoading: isLoading,
                  buttonTitle: "Upload",
                  isPurple: true,
                  onPressed: () async {
                    await uploadImage();
                    if (context.mounted) {
                      MemoryProvider memoryProvider = Provider.of(context);
                      await memoryProvider.fetchUserMemories();
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
