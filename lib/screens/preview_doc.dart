import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../config/UI_constraints.dart';
import '../widgets/primary_button.dart';

class PreviewDocScreen extends StatelessWidget {
  final String docName;
  final String docType;
  final String docURL;
  final String uploadTime;
  const PreviewDocScreen(
      {super.key,
      required this.docName,
      required this.docType,
      required this.docURL,
      required this.uploadTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    docName,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Uploaded on: $uploadTime')),
                const SizedBox(height: 40),
                docType == 'image/jpeg'
                    ? Image.network(docURL,
                        height: MediaQuery.of(context).size.height * 0.5)
                    : Text(docURL),
                const SizedBox(height: 40),
                PrimaryButton(
                  buttonTitle: 'Download',
                  onPressed: () async {
                    await GallerySaver.saveImage(docURL).then((value) {
                      var snackBar = const SnackBar(
                          content: Text('Image Saved in Gallery'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
