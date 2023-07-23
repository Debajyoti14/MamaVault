import 'package:flutter/cupertino.dart';
import 'package:interrupt/repository/dashboard_repository.dart';

import '../data/response/api_response.dart';

class DashboardViewModel extends ChangeNotifier {
  final _dashboardRepo = DashboardRepository();

  ApiResponse<dynamic> timeline = ApiResponse.loading();

  void setDashboardTimeline(ApiResponse<dynamic> response) {
    timeline = response;
    notifyListeners();
  }

  Future<void> getTimeline(String allDocs) async {
    setDashboardTimeline(ApiResponse.loading());
    _dashboardRepo.getTimeline(allDocs).then((value) {
      setDashboardTimeline(ApiResponse.complete(value));
    }).onError((error, stackTrace) {
      setDashboardTimeline(ApiResponse.error(error.toString()));
    });
  }
}
