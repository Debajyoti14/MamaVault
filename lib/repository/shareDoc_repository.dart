import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:interrupt/data/network/baseApiServices.dart';
import 'package:interrupt/data/network/networkApiServices.dart';
import 'package:interrupt/resources/app_url.dart';

class ShareDocrepository {
  final BaseApiServices _apiServices = NetworkAPIService();
  Future<dynamic> getSharableLink(Map<String, dynamic> data) async {
    try {
      dynamic response = await _apiServices.postApiResponse(
          AppUrl.getSharableLink, jsonEncode(data));
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<dynamic> deleteSharedDoc(String sharedDocID, String uid) async {
    try {
      Map<String, dynamic> data = {
        "uid": uid, // user id
        "share_doc_id": sharedDocID
      };
      dynamic response = await _apiServices.postApiResponse(
          AppUrl.deleteSharableLink, jsonEncode(data));
      return response;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
