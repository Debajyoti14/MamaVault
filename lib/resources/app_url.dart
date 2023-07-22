import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppUrl {
  static var baseUrl =
      "https://6uhblhr9j5.execute-api.eu-north-1.amazonaws.com/dev";

  static var getTimeline =
      "$baseUrl/get-timeline?apikey=${dotenv.env['API_KEY']!}";
}
