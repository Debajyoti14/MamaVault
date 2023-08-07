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

String formatdateTimeToStoreInFireStore(DateTime dateTime) {
  String formattedDate = DateFormat('E MMM dd yyyy HH:mm:ss').format(dateTime);

  // Get the timezone offset in the format "+HH:mm" or "-HH:mm"
  String timezoneOffset = dateTime.timeZoneOffset.inHours >= 0
      ? '+${dateTime.timeZoneOffset.inHours.toString().padLeft(2, '0')}:${dateTime.timeZoneOffset.inMinutes.remainder(60).toString().padLeft(2, '0')}'
      : '-${dateTime.timeZoneOffset.inHours.abs().toString().padLeft(2, '0')}:${dateTime.timeZoneOffset.inMinutes.remainder(60).abs().toString().padLeft(2, '0')}';

  // Get the timezone name
  String timezoneName = getAbbreviationForTimezone(dateTime.timeZoneName);

  // Combine the timezone offset and name to get the desired format
  String timezoneInformation = 'GMT$timezoneOffset ($timezoneName)';
  return "$formattedDate $timezoneInformation";
}

// Function to get the timezone abbreviation from the full timezone name
String getAbbreviationForTimezone(String timezoneName) {
  switch (timezoneName) {
    case 'UTC':
      return 'Coordinated Universal Time';
    case 'IST':
      return 'India Standard Time';
    case 'EST':
      return 'Eastern Standard Time';
    case 'PST':
      return 'Pacific Standard Time';
    case 'CST':
      return 'Central Standard Time';
    case 'MST':
      return 'Mountain Standard Time';
    case 'BST':
      return 'British Summer Time';
    // Add more cases for other shorthand timezone abbreviations as needed
    default:
      return timezoneName;
  }
}

String viableDateString(String inputDate) {
  // Extract the day of the week from the input string
  String dayOfWeek = inputDate.substring(0, 3);

  // Extract the date part from the input string
  String datePart = inputDate.substring(4, 15);

  // Combine day of the week and date to form a parsable date string
  String parsableDateString = '$dayOfWeek $datePart';

  // Parse the parsable date string into a DateTime object
  DateTime dateTime = DateFormat('E MMM dd yyyy').parse(parsableDateString);

  // Format the DateTime object to the desired output format
  String formattedDate = DateFormat('E MMM dd yyyy').format(dateTime);
  return formattedDate;
}
