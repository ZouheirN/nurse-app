// convert DateTime to "2024-10-01 12:00:00" format
String convertDateTime(DateTime dateTime) {
  return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
}