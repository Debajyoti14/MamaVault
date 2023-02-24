import 'package:intl/intl.dart';

String format12hourTime(int lastSeen) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(lastSeen);
  String formatteddate = DateFormat('MM/dd/yyyy, hh:mm a').format(date);
  return formatteddate;
}
