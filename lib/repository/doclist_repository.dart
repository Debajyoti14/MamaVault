import 'package:flutter/material.dart';

import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';
import '../resources/app_url.dart';

class DocListRepository {
  final BaseApiServices _apiServices = NetworkAPIService();
  Future<dynamic> getSharableLink(Map<String, dynamic> data) async {
    try {
      dynamic response =
          await _apiServices.postApiResponse(AppUrl.getSharableLink, data);
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
