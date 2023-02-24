import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:interrupt/config/color_pallete.dart';

import '../config/UI_constraints.dart';
import 'doc_list.dart';

class DocsGalleryScreen extends StatelessWidget {
  const DocsGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List docCategories = [
      'USG Reports',
      'Non-Stress Test',
      'Contraction Stress Test',
      'Doppler Ultrasound Report',
      'Others'
    ];
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
            height: MediaQuery.of(context).size.height,
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
                      'Docs Gallery',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 40),
                  GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: docCategories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => const DocListScreen()),
                          );
                        },
                        child: Column(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.solidFolder,
                              color: PalleteColor.primaryPurple,
                              size: 122,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              docCategories[index],
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      );
                    },
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
