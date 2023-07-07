import 'package:intl/intl.dart';

String format12hourTime(int lastSeen) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(lastSeen);
  String formatteddate = DateFormat('dd/MM/yyyy').format(date);
  return formatteddate;
}

String formatDate(DateTime dateTime) {
  final monthNames = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String day = dateTime.day.toString().padLeft(2, '0');
  String month = monthNames[dateTime.month];
  String year = dateTime.year.toString().substring(2);

  return '$day $month, $year';
}
