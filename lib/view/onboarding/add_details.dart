import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interrupt/resources/UI_constraints.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/utils/date_formatter.dart';
import 'package:interrupt/resources/components/custom_text_field.dart';
import '../../resources/components/primary_button.dart';
import 'add_medical_records.dart';

class AddDetailsScreen extends StatefulWidget {
  const AddDetailsScreen({super.key});

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  final nameController = TextEditingController(
      text: FirebaseAuth.instance.currentUser!.displayName);
  final emailController =
      TextEditingController(text: FirebaseAuth.instance.currentUser!.email);
  final ageController = TextEditingController();
  String bloodGroup = '';
  final dateController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  bool isLoading = false;

  Future addDetailsUser() async {
    isLoading = true;
    setState(() {});
    final user = FirebaseAuth.instance.currentUser!;

    final finalUser =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final data = {
      'name': nameController.text,
      'email': emailController.text,
      'age': ageController.text,
      'date_of_pregnancy': _selectedDate,
      'uid': user.uid,
      'image': user.photoURL
    };
    await finalUser.update(data);
    isLoading = false;
    setState(() {});
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
    final user = FirebaseAuth.instance.currentUser!;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding),
            height: size.height,
            width: size.width,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add Details',
                      style: TextStyle(
                          fontSize: 32.sp, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryPurple,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoURL!,
                      ),
                      radius: 45,
                    ),
                  ),
                  SizedBox(height: 50.h),
                  CustomTextField(
                    hintText: 'Enter Your Name',
                    controller: nameController,
                    height: 20.h,
                  ),
                  SizedBox(height: 10.h),
                  CustomTextField(
                    hintText: 'Enter Your Email',
                    controller: emailController,
                    height: 20.h,
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          width: 170.w,
                          height: 23.h,
                          hintText: 'Enter Your Age',
                          controller: ageController,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Age Required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 13.w),
                      SizedBox(
                        width: 172.w,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: AppColors.primaryPurple),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 13,
                            ),
                          ),
                          hint: const Text('Blood Group'),
                          isExpanded: true,
                          items: <String>[
                            'O+',
                            'O-',
                            'A+',
                            'A-',
                            'B+',
                            'B-',
                            'AB+',
                            'AB-'
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            bloodGroup = value!;
                          },
                          validator: (value) {
                            if (bloodGroup == '') {
                              return 'Blood Group is required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select Pregnancy Starting Time'),
                  ),
                  SizedBox(height: 5.h),
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
                          borderSide:
                              BorderSide(color: AppColors.primaryPurple),
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
                  SizedBox(height: 100.h),
                  PrimaryButton(
                    buttonTitle: 'Next',
                    isLoading: isLoading,
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await addDetailsUser();
                        if (context.mounted) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const AddMedicalRecordsScreen(),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
