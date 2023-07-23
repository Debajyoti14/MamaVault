import 'package:flutter/material.dart';
import 'package:interrupt/resources/app_url.dart';

import '../data/network/baseApiServices.dart';
import '../data/network/networkApiServices.dart';

class DashboardRepository {
  final BaseApiServices _apiServices = NetworkAPIService();
  Future<dynamic> getTimeline(String alldocs) async {
    try {
      dynamic response = await _apiServices
          .postApiResponse(AppUrl.getTimeline, {"documents": alldocs});
      return response;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}
