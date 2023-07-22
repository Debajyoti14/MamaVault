import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/view/home_page.dart';
import 'package:interrupt/resources/components/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/UI_constraints.dart';
import '../../resources/components/custom_text_field.dart';

class AddMedicalRecordsScreen extends StatefulWidget {
  const AddMedicalRecordsScreen({super.key});

  @override
  State<AddMedicalRecordsScreen> createState() =>
      _AddMedicalRecordsScreenState();
}

class _AddMedicalRecordsScreenState extends State<AddMedicalRecordsScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _diseaseEditingController =
      TextEditingController();
  final TextEditingController _medicineEditingController =
      TextEditingController();
  final TextEditingController _allergyEditingController =
      TextEditingController();

  List<String> _diseasesValues = [];
  List<bool> _diseaseSelected = [];

  List<String> _medicineValues = [];
  List<bool> _medicineSelected = [];

  List<String> _allergyValues = [];
  List<bool> _allergySelected = [];

  bool isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _diseaseEditingController.dispose();
    _medicineEditingController.dispose();
    _allergyEditingController.dispose();
    super.dispose();
  }

  Future addMedicalDetailsUser() async {
    final user = FirebaseAuth.instance.currentUser!;
    try {
      isLoading = true;
      setState(() {});
      final finalUser =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final data = {
        'complications_description ': _descriptionController.text,
        'medicines ': _medicineValues,
        'diseases ': _diseasesValues,
        'allegies ': _allergyValues,
      };
      await finalUser.update(data);
      isLoading = false;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Widget buildChips(List<String> values, List<bool> selectedValues) {
    List<Widget> chips = [];

    for (int i = 0; i < values.length; i++) {
      Widget actionChip = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3.0),
        child: InputChip(
          selectedColor: AppColors.primaryPurple,
          deleteIconColor: AppColors.bodyTextColorLight,
          showCheckmark: false,
          backgroundColor: AppColors.bodyTextColorLight,
          selected: selectedValues[i],
          label: Text(
            values[i],
            style: const TextStyle(color: AppColors.bodyTextColorLight),
          ),
          elevation: 0,
          pressElevation: 5,
          onPressed: () {
            setState(() {
              selectedValues[i] = !selectedValues[i];
            });
          },
          onDeleted: () {
            values.removeAt(i);
            selectedValues.removeAt(i);

            setState(() {
              values = values;
              selectedValues = selectedValues;
            });
          },
        ),
      );

      chips.add(actionChip);
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: 30.h),
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40.h),
                      Text(
                        'Medical Records',
                        style: TextStyle(
                            fontSize: 32.sp, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                      // SizedBox(height: 20.h),
                      // Image.asset('assets/add_medical_records.png'),
                      SizedBox(height: 40.h),
                      CustomTextField(
                        hintText: 'Enter Description',
                        controller: _descriptionController,
                        height: 40.h,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'Description is required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0.h),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 44.h,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  buildChips(_diseasesValues, _diseaseSelected),
                            ),
                            TextFormField(
                              controller: _diseaseEditingController,
                              decoration: InputDecoration(
                                hintText: 'Diseases',
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryPurple),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 13,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: AppColors.primaryPurple,
                                  ),
                                  onPressed: () {
                                    _diseasesValues
                                        .add(_diseaseEditingController.text);
                                    _diseaseSelected.add(true);
                                    _diseaseEditingController.clear();

                                    setState(() {
                                      _diseasesValues = _diseasesValues;
                                      _diseaseSelected = _diseaseSelected;
                                      debugPrint(_diseasesValues.toString());
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //For Medicines
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0.h),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 44.h,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: buildChips(
                                  _medicineValues, _medicineSelected),
                            ),
                            TextFormField(
                              controller: _medicineEditingController,
                              decoration: InputDecoration(
                                hintText: 'Medicines',
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryPurple),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 13,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: AppColors.primaryPurple,
                                  ),
                                  onPressed: () {
                                    _medicineValues
                                        .add(_medicineEditingController.text);
                                    _medicineSelected.add(true);
                                    _medicineEditingController.clear();

                                    setState(() {
                                      _medicineValues = _medicineValues;
                                      _medicineSelected = _medicineSelected;
                                      debugPrint(_medicineValues.toString());
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //For Allergies
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0.h),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 44.h,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child:
                                  buildChips(_allergyValues, _allergySelected),
                            ),
                            TextFormField(
                              controller: _allergyEditingController,
                              decoration: InputDecoration(
                                hintText: 'Allergies',
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primaryPurple),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                  horizontal: 13,
                                ),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.check,
                                      color: AppColors.primaryPurple),
                                  onPressed: () {
                                    _allergyValues
                                        .add(_allergyEditingController.text);
                                    _allergySelected.add(true);
                                    _allergyEditingController.clear();

                                    setState(() {
                                      _allergyValues = _allergyValues;
                                      _allergySelected = _allergySelected;
                                      debugPrint(_allergyValues.toString());
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 153.w,
                        height: 60.h,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            Navigator.of(context).pushAndRemoveUntil(
                                CupertinoPageRoute(
                                    builder: (_) => const Home()),
                                (route) => false);
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setBool('isOnboarded', true);
                          },
                          icon: const Icon(Icons.skip_next,
                              color: AppColors.primaryPurple),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Skip',
                              style: TextStyle(color: AppColors.primaryPurple),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            backgroundColor: AppColors.bodyTextColorLight,
                            textStyle: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      SizedBox(
                        width: 153.w,
                        child: PrimaryButton(
                            buttonTitle: 'Save',
                            isLoading: isLoading,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                addMedicalDetailsUser().then((value) async {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      CupertinoPageRoute(
                                          builder: (_) => const Home()),
                                      (route) => false);
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setBool('isOnboarded', true);
                                });
                              }
                            }),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
