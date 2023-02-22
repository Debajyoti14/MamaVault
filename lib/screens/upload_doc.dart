import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io' as io;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interrupt/config/UI_constraints.dart';
import 'package:interrupt/config/color_pallete.dart';
import 'package:interrupt/widgets/primary_icon_button.dart';

class UploadDoc extends StatefulWidget {
  const UploadDoc({super.key});

  @override
  State<UploadDoc> createState() => _UploadDocState();
}

class _UploadDocState extends State<UploadDoc> {
  List uploadedImageURL = [];
  final ImagePicker imagePicker = ImagePicker();

  List<XFile> imageFileList = [];
  List<XFile> currentImages = [];
  bool isSelected = true;
  late String displayImageUrl = "assets/imageUploadIcon.png";

  Future openPicker() async {
    List<XFile> currentImage = await imagePicker.pickMultiImage();

    if (currentImage.isNotEmpty) {
      currentImages.addAll(currentImage);
      setState(() {
        isSelected = false;
      });
    }
  }

  void selectImages() {
    setState(() {
      imageFileList.addAll(currentImages);
      currentImages = [];
      isSelected = true;
    });
    Navigator.pop(context);
  }

  //   _uploadMultipleImages() async {
  //   for (var image in imageFileList) {
  //     final url = await _uploadImages(image);
  //     uploadedImageURL.add(url);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            Text(
              "Upload Document",
              style: TextStyle(
                fontSize: 32,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Documents',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.bold)
                              .fontFamily,
                    ),
                  ),
                  Text(
                    'Minimum 1 Image required',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily:
                          GoogleFonts.poppins(fontWeight: FontWeight.w500)
                              .fontFamily,
                    ),
                  ),
                ],
              ),
              (imageFileList.length < 3)
                  ? IconButton(
                      color: PalleteColor.primaryPurple,
                      icon: const Icon(Icons.add_a_photo),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return bottomSheet();
                            });
                      },
                    )
                  : const Text('Max 3 Images!'),
            ]),
            const SizedBox(
              height: 20,
            ),
            (imageFileList.isNotEmpty)
                ? GridView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: imageFileList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, crossAxisSpacing: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        io.File(imageFileList[index].path),
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Container(),
            const SizedBox(height: 20),
          ],
        )),
      ),
    );
  }

  SizedBox bottomSheet() {
    return SizedBox(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Text(
              'Choose Image',
              style: TextStyle(
                fontSize: 18,
                fontFamily:
                    GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            (isSelected)
                ? InkWell(
                    onTap: () async {
                      print(isSelected);
                      await openPicker();
                      print("Here");
                      print(isSelected);
                    },
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color.fromARGB(255, 224, 223, 223),
                        ),
                      ),
                      child: Image.asset(displayImageUrl),
                    ),
                  )
                : Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color.fromARGB(255, 224, 223, 223),
                      ),
                    ),
                    child: Image.file(
                      io.File(currentImages[0].path),
                      fit: BoxFit.contain,
                    ),
                  ),
            const SizedBox(
              height: 40,
            ),
            PrimaryIconButton(
                buttonTitle: "Upload",
                buttonIcon: const FaIcon(FontAwesomeIcons.image),
                onPressed: selectImages)
          ],
        ),
      ),
    );
  }
}
