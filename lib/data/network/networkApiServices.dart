import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:interrupt/data/app_exceptions.dart';
import 'package:interrupt/data/network/baseApiServices.dart';

class NetworkAPIService implements BaseApiServices {
  @override
  Future getApiResponse(String url) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'x-api-key': dotenv.env['API_KEY']!,
          'content-type': 'application/json'
        },
      ).timeout(const Duration(seconds: 10));
      return returnResponse(response);
    } on SocketException {
      throw FetchException('No Internet');
    }
  }

  @override
  Future postApiResponse(String url, dynamic data) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {
          'x-api-key': dotenv.env['API_KEY']!,
        },
      ).timeout(const Duration(seconds: 10));
      return returnResponse(response);
    } on SocketException {
      throw FetchException('No Internet');
    }
  }

  dynamic returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.body.toString());
      case 500:
      case 404:
        throw UnauthorizedException(response.body.toString());
      default:
        throw FetchException(
            'Error accured while communicating with serverwith status code${response.statusCode}');
    }
  }
}
