import 'dart:convert';

import 'package:interrupt/data/network/baseApiServices.dart';
import 'package:interrupt/data/network/networkApiServices.dart';
import 'package:interrupt/resources/app_url.dart';

class PanicRepository {
  final BaseApiServices _apiServices = NetworkAPIService();

  Future<dynamic> sendPanicRequest({
    required String uid,
    required String name,
  }) async {
    Map data = {
      "uid": uid,
      "name": name,
      "location_link": "Anadapur, Kolkata", // get the location from the user
    };
    dynamic response = await _apiServices.postApiResponse(
        AppUrl.sendPanicRequest, jsonEncode(data));
    return response;
  }

  Future<dynamic> sendNumberDetails(
      {required String uid,
      required String name,
      required String number}) async {
    Map data = {
      "uid": uid,
      "name": name,
      "number": "+91$number",
    };
    dynamic response = await _apiServices.postApiResponse(
        AppUrl.addEmergencyMobileNo, jsonEncode(data));
    return response;
  }

  Future<dynamic> deleteNumber({
    required String uid,
    required String verificationID,
  }) async {
    Map data = {
      "uid": uid, // user id
      "verification_id": verificationID, // mobile number id
      "action": "Delete"
    };
    dynamic response = await _apiServices.postApiResponse(
        AppUrl.deleteEmergencyMobileNo, jsonEncode(data));
    return response;
  }
}
