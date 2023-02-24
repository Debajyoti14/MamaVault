import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

import '../config/UI_constraints.dart';
import '../widgets/primary_button.dart';

class PreviewDocScreen extends StatefulWidget {
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
  State<PreviewDocScreen> createState() => _PreviewDocScreenState();
}

class _PreviewDocScreenState extends State<PreviewDocScreen> {
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
                    widget.docName,
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Uploaded on: ${widget.uploadTime}')),
                const SizedBox(height: 40),
                widget.docType == 'image/jpeg'
                    ? Image.network(widget.docURL,
                        height: MediaQuery.of(context).size.height * 0.5)
                    // : const Text('Any'),
                    : FutureBuilder<File>(
                        future:
                            DefaultCacheManager().getSingleFile(widget.docURL),
                        builder: (context, snapshot) => snapshot.hasData
                            ? SingleChildScrollView(
                                child: SizedBox(
                                  height: 500,
                                  width: 300,
                                  child: PdfViewer.openFile(
                                    snapshot.data!.path,
                                  ),
                                ),
                              )
                            : Container(),
                      ),
                const SizedBox(height: 40),
                PrimaryButton(
                  buttonTitle: 'Download',
                  onPressed: () async {
                    await GallerySaver.saveImage(widget.docURL).then((value) {
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
