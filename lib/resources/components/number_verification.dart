import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/repository/panic_repository.dart';
import 'package:interrupt/utils/utils.dart';
import 'package:interrupt/view_model/theme_provider.dart';
import 'package:provider/provider.dart';

import '../colors.dart';

class NumberVerify extends StatelessWidget {
  final String number;
  final String status;
  final String verifyId;
  final Function refresh;

  const NumberVerify({
    super.key,
    required this.number,
    required this.status,
    required this.verifyId,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    PanicRepository panicRepository = PanicRepository();
    final user = FirebaseAuth.instance.currentUser!;
    final themeChange = Provider.of<ThemeProvider>(context);

    Future<void> showMyDialogForDeleteEmergencyNos() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Are you sure?',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            content: const Text('The contacts will be deleted permanently'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel',
                    style: TextStyle(color: AppColors.primaryPurple)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  panicRepository
                      .deleteNumber(
                    uid: user.uid,
                    verificationID: verifyId,
                  )
                      .then((value) {
                    refresh();
                    Navigator.of(context).pop();
                    Utils.toastMessage("Emergency Contact Deleted");
                  });
                },
              ),
            ],
          );
        },
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: themeChange.darkTheme
              ? AppColors.primaryPurple
              : const Color.fromARGB(255, 245, 246, 254),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.primaryPurple,
          ),
        ),
        child: SingleChildScrollView(
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: Text(
                      number,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)
                                .fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (status == "Waiting for confirmation")
                                ? Colors.yellow
                                : Colors.green),
                        height: 12,
                        width: 12,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          color: themeChange.darkTheme
                              ? Colors.white
                              : const Color.fromARGB(255, 122, 122, 122),
                          fontSize: 13,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                  .fontFamily,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 29,
              ),
              InkWell(
                onTap: showMyDialogForDeleteEmergencyNos,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Image.asset('assets/delIcon.png'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
