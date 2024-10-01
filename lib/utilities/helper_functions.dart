// convert DateTime to "2024-10-01 12:00:00" format
// String convertDateTime(DateTime dateTime) {
//   return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
// }

String formatDateTimeForHistoryCard(DateTime dateTime) {
  return '${dateTime.hour}:${dateTime.minute}\n${dateTime.month}/${dateTime.day}/${dateTime.year}';
}

String formateDateTimeForRequestDetails(DateTime dateTime) {
  return '${dateTime.month}/${dateTime.day}/${dateTime.year}@${dateTime.hour}:${dateTime.minute} ${dateTime.hour > 12 ? 'pm' : 'am'}';
}