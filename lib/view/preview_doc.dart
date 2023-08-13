import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:interrupt/utils/date_formatter.dart';
import 'package:pdf_render/pdf_render_widgets.dart';

import '../resources/UI_constraints.dart';
import '../resources/colors.dart';
import '../resources/components/primary_button.dart';

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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppColors.primaryPurple),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 30),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.docName,
                  style:
                      TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Text('Uploaded on: ${viableDateString(widget.uploadTime)}'),
                SizedBox(height: 40.h),
                widget.docType == 'image/jpeg'
                    ? ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: widget.docURL,
                          width: MediaQuery.sizeOf(context).width,
                          height: MediaQuery.sizeOf(context).height * 0.55,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.primaryPurple,
                          )),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      )
                    : FutureBuilder<File>(
                        future:
                            DefaultCacheManager().getSingleFile(widget.docURL),
                        builder: (context, snapshot) => snapshot.hasData
                            ? SingleChildScrollView(
                                child: SizedBox(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.55,
                                  width: 300.w,
                                  child: PdfViewer.openFile(
                                    snapshot.data!.path,
                                  ),
                                ),
                              )
                            : Container(),
                      ),
              ],
            ),
            PrimaryButton(
              buttonTitle: 'Download',
              onPressed: () async {
                await GallerySaver.saveImage(widget.docURL).then((value) {
                  var snackBar =
                      const SnackBar(content: Text('Image Saved in Gallery'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
