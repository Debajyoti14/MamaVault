// ignore_for_file: public_member_api_docs, sort_constructors_first

import '../utils/date_formatter.dart';

class DocumentModel {
  final String docId;
  final String docTitle;
  final String docType;
  final String docFormat;
  final String docUrl;
  final String timelineTime;
  final String uploadTime;

  DocumentModel({
    required this.docId,
    required this.docTitle,
    required this.docType,
    required this.docFormat,
    required this.docUrl,
    required this.timelineTime,
    required this.uploadTime,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'doc_id': docId,
      'doc_title': docTitle,
      'doc_type': docType,
      'doc_format': docFormat,
      'doc_url': docUrl,
      'timeline_time': timelineTime,
      'upload_time': uploadTime,
    };
  }

  factory DocumentModel.fromJson(Map<String, dynamic> map) {
    return DocumentModel(
      docId: map['doc_id'] as String,
      docTitle: map['doc_title'] as String,
      docType: map['doc_type'] as String,
      docFormat: map['doc_format'] as String,
      docUrl: map['doc_url'] as String,
      timelineTime:
          convertFirebaseTimestampToFormattedString(map['timeline_time']),
      uploadTime: convertFirebaseTimestampToFormattedString(map['upload_time']),
    );
  }
}
