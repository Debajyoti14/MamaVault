import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interrupt/repository/shareDoc_repository.dart';

import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/utils/utils.dart';
import 'package:interrupt/view_model/theme_provider.dart';
import 'package:provider/provider.dart';

class ExpireLink extends StatefulWidget {
  final String sharedDocID;
  final String link;
  final String date;
  final String views;
  const ExpireLink({
    super.key,
    required this.link,
    required this.date,
    required this.views,
    required this.sharedDocID,
  });

  @override
  State<ExpireLink> createState() => _ExpireLinkState();
}

class _ExpireLinkState extends State<ExpireLink> {
  ShareDocrepository shareDocRepository = ShareDocrepository();

  Future<void> showMyDialogForDeleteLinks(
      String sharedDocID, String uid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Are you sure?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: const Text('The Shared Link will be deleted permanently'),
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
              onPressed: () {
                shareDocRepository
                    .deleteSharedDoc(sharedDocID, uid)
                    .then((value) {
                  Utils.toastMessage("Shared Document Deleted");
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final themeChange = Provider.of<ThemeProvider>(context);

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
                      widget.link,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily:
                            GoogleFonts.poppins(fontWeight: FontWeight.w700)
                                .fontFamily,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    'Will expire on ${widget.date}',
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
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_sharp,
                        color: themeChange.darkTheme
                            ? Colors.white
                            : Colors.black45,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        widget.views,
                        style: TextStyle(
                          color: themeChange.darkTheme
                              ? Colors.white
                              : const Color.fromARGB(255, 122, 122, 122),
                          fontSize: 14,
                          fontFamily:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)
                                  .fontFamily,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                width: 29,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: InkWell(
                  onTap: () {
                    showMyDialogForDeleteLinks(widget.sharedDocID, user.uid);
                    // .then((value) {
                    // setState(() {});
                    // var snackBar = const SnackBar(
                    //     content: Text('Link Deleted Successfully'));
                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    // });
                  },
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
