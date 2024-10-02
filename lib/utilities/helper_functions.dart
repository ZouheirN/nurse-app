// convert DateTime to "2024-10-01 12:00:00" format
// String convertDateTime(DateTime dateTime) {
//   return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
// }

String formatDateTimeForCard(DateTime dateTime) {
  return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}\n${dateTime.month}/${dateTime.day}/${dateTime.year}';
}

String formateDateTimeForRequestDetails(DateTime dateTime) {
  return '${dateTime.month}/${dateTime.day}/${dateTime.year}@${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour > 12 ? 'pm' : 'am'}';
}

// String formatPrice(String number) {
//   if (number == number.roundToDouble()) {
//     return number.toStringAsFixed(0);
//   } else {
//     return number.toString();
//   }
// }

String formatPrice(String price) {
  double priceValue = double.parse(price);

  if (priceValue == priceValue.roundToDouble()) {
    return priceValue.toInt().toString();
  } else {
    return priceValue.toStringAsFixed(2);
  }
}