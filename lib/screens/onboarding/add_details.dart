import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/widgets/custom_text_field.dart';

import '../../config/color_pallete.dart';
import '../../widgets/primary_button.dart';
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

  Future addDetailsUser() async {
    final user = FirebaseAuth.instance.currentUser!;

    final finalUser =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final data = {
      'name': nameController.text,
      'email': emailController.text,
      'age': ageController.text,
      'date_of_pregnancy': dateController.text,
      'uid': user.uid,
      'image': user.photoURL
    };
    await finalUser.update(data);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            height: MediaQuery.of(context).size.height * 1.05,
            width: MediaQuery.of(context).size.width,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Add Details',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 40),
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: PalleteColor.primaryPurple,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.photoURL!,
                      ),
                      radius: 45,
                    ),
                  ),
                  const SizedBox(height: 50),
                  CustomTextField(
                    hintText: 'Enter Your Name',
                    controller: nameController,
                    height: 20,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Enter Your Email',
                    controller: emailController,
                    height: 20,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        child: CustomTextField(
                          width: 166,
                          height: 20,
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
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 165,
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
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
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Select Pregnancy Starting Time'),
                  ),
                  const SizedBox(height: 5),
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
                    onSaved: (val) => print(val),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Date is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 150),
                  PrimaryButton(
                      buttonTitle: 'Next',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          print(dateController.text);
                          addDetailsUser();
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => const AddMedicalRecordsScreen(),
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DateFormat {}
