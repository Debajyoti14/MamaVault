import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:interrupt/model/document_model.dart';
import 'package:interrupt/resources/colors.dart';
import 'package:interrupt/utils/date_formatter.dart';
import 'package:interrupt/view/preview_doc.dart';

// ignore: must_be_immutable
class IndividualDoc extends StatefulWidget {
  final DocumentModel docData;
  final String documentTitle;
  final String documentID;
  final String time;
  final void Function(dynamic, dynamic) callback;
  final List selectedDocuments;
  bool isSelectedDoc;
  IndividualDoc(
      {super.key,
      required this.documentTitle,
      required this.time,
      this.isSelectedDoc = false,
      required this.callback,
      required this.selectedDocuments,
      required this.documentID,
      required this.docData});

  @override
  State<IndividualDoc> createState() => _IndividualDocState();
}

class _IndividualDocState extends State<IndividualDoc> {
  bool isIndividualSelected = false;
  @override
  Widget build(BuildContext context) {
    isIndividualSelected =
        (widget.selectedDocuments.contains(widget.documentID));
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (_) => PreviewDocScreen(
                      uploadTime: widget.docData.uploadTime,
                      docName: widget.documentTitle,
                      docType: widget.docData.docFormat,
                      docURL: widget.docData.docUrl,
                    )));
      },
      child: Container(
        width: double.infinity,
        height: 70,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 223, 223, 247),
          border: Border.all(width: 2, color: AppColors.primaryPurple),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.documentTitle,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  viableDateString(widget.time),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Checkbox(
              checkColor: Colors.white,
              activeColor: AppColors.primaryPurple,
              value: isIndividualSelected,
              shape: const CircleBorder(),
              onChanged: (bool? value) {
                setState(() {
                  value == true
                      ? widget.selectedDocuments.add(widget.documentID)
                      : widget.selectedDocuments.remove(widget.documentID);
                  isIndividualSelected = value!;
                  widget.selectedDocuments.toSet().toList();
                  value == true
                      ? widget.callback(
                          widget.selectedDocuments, widget.isSelectedDoc)
                      : widget.callback(widget.selectedDocuments, false);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
