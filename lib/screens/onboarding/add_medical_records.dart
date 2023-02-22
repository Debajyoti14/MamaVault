import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/screens/home_page.dart';
import 'package:interrupt/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/UI_constraints.dart';
import '../../config/color_pallete.dart';
import '../../widgets/custom_text_field.dart';

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
      final finalUser =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final data = {
        'complications_description ': _descriptionController.text,
        'medicines ': _medicineValues,
        'diseases ': _diseasesValues,
        'allegies ': _allergyValues,
      };
      await finalUser.update(data);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget buildChipsDisease() {
    List<Widget> chips = [];

    for (int i = 0; i < _diseasesValues.length; i++) {
      InputChip actionChip = InputChip(
        selectedColor: PalleteColor.primaryPurple,
        deleteIconColor: PalleteColor.bodyTextColorLight,
        showCheckmark: false,
        backgroundColor: PalleteColor.bodyTextColorLight,
        selected: _diseaseSelected[i],
        label: Text(
          _diseasesValues[i],
          style: const TextStyle(color: PalleteColor.bodyTextColorLight),
        ),
        // avatar: FlutterLogo(),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onPressed: () {
          setState(() {
            _diseaseSelected[i] = !_diseaseSelected[i];
          });
        },
        onDeleted: () {
          _diseasesValues.removeAt(i);
          _diseaseSelected.removeAt(i);

          setState(() {
            _diseasesValues = _diseasesValues;
            _diseaseSelected = _diseaseSelected;
          });
        },
      );

      chips.add(actionChip);
    }

    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  Widget buildChipsMedicine() {
    List<Widget> chips = [];

    for (int i = 0; i < _medicineValues.length; i++) {
      InputChip actionChip = InputChip(
        selectedColor: PalleteColor.primaryPurple,
        deleteIconColor: PalleteColor.bodyTextColorLight,
        showCheckmark: false,
        backgroundColor: PalleteColor.bodyTextColorLight,
        selected: _diseaseSelected[i],
        label: Text(
          _medicineValues[i],
          style: const TextStyle(color: PalleteColor.bodyTextColorLight),
        ),
        // avatar: FlutterLogo(),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onPressed: () {
          setState(() {
            _medicineSelected[i] = !_medicineSelected[i];
          });
        },
        onDeleted: () {
          _medicineValues.removeAt(i);
          _medicineSelected.removeAt(i);

          setState(() {
            _medicineValues = _medicineValues;
            _medicineSelected = _medicineSelected;
          });
        },
      );

      chips.add(actionChip);
    }

    return ListView(
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  Widget buildChipsAllergy() {
    List<Widget> chips = [];

    for (int i = 0; i < _allergyValues.length; i++) {
      InputChip actionChip = InputChip(
        selectedColor: PalleteColor.primaryPurple,
        deleteIconColor: PalleteColor.bodyTextColorLight,
        showCheckmark: false,
        backgroundColor: PalleteColor.bodyTextColorLight,
        selected: _allergySelected[i],
        label: Text(
          _allergyValues[i],
          style: const TextStyle(color: PalleteColor.bodyTextColorLight),
        ),
        // avatar: FlutterLogo(),
        elevation: 10,
        pressElevation: 5,
        shadowColor: Colors.teal,
        onPressed: () {
          setState(() {
            _allergySelected[i] = !_allergySelected[i];
          });
        },
        onDeleted: () {
          _allergyValues.removeAt(i);
          _allergySelected.removeAt(i);

          setState(() {
            _allergyValues = _allergyValues;
            _allergySelected = _allergySelected;
          });
        },
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
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            height: MediaQuery.of(context).size.height * 1.1,
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
                      'Medical Records',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Image.asset('assets/add_medical_records.png'),
                  const SizedBox(height: 40),
                  CustomTextField(
                    hintText: 'Enter Description',
                    controller: _descriptionController,
                    height: 40,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'Description is required';
                      } else {
                        return null;
                      }
                    },
                  ),
                  // const SizedBox(height: 20),
                  //For Diseases
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                          child: buildChipsDisease(),
                        ),
                        TextFormField(
                          controller: _diseaseEditingController,
                          decoration: InputDecoration(
                            hintText: 'Diseases',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                _diseasesValues
                                    .add(_diseaseEditingController.text);
                                _diseaseSelected.add(true);
                                _diseaseEditingController.clear();

                                setState(() {
                                  _diseasesValues = _diseasesValues;
                                  _diseaseSelected = _diseaseSelected;
                                  print(_diseasesValues);
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
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                          child: buildChipsMedicine(),
                        ),
                        TextFormField(
                          controller: _medicineEditingController,
                          decoration: InputDecoration(
                            hintText: 'Medicines',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                _medicineValues
                                    .add(_medicineEditingController.text);
                                _medicineSelected.add(true);
                                _medicineEditingController.clear();

                                setState(() {
                                  _medicineValues = _medicineValues;
                                  _medicineSelected = _medicineSelected;
                                  print(_medicineValues);
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
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                          child: buildChipsAllergy(),
                        ),
                        TextFormField(
                          controller: _allergyEditingController,
                          decoration: InputDecoration(
                            hintText: 'Allergies',
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.check),
                              onPressed: () {
                                _allergyValues
                                    .add(_allergyEditingController.text);
                                _allergySelected.add(true);
                                _allergyEditingController.clear();

                                setState(() {
                                  _allergyValues = _allergyValues;
                                  _allergySelected = _allergySelected;
                                  print(_allergyValues);
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 153,
                        height: 60,
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
                              color: PalleteColor.primaryPurple),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'Skip',
                              style:
                                  TextStyle(color: PalleteColor.primaryPurple),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            backgroundColor: PalleteColor.bodyTextColorLight,
                            textStyle: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 153,
                        child: PrimaryButton(
                            buttonTitle: 'Save',
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
