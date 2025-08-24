// convert DateTime to "2024-10-01 12:00:00" format
// String convertDateTime(DateTime dateTime) {
//   return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
// }

String formatDateTimeForCard(DateTime dateTime) {
  var dateLocal = dateTime.toLocal();
  return '${dateLocal.hour.toString().padLeft(2, '0')}:${dateLocal.minute.toString().padLeft(2, '0')}\n${dateLocal.month}/${dateLocal.day}/${dateLocal.year}';
}

String formateDateTimeForRequestDetails(DateTime dateTime) {
  var dateLocal = dateTime.toLocal();
  return '${dateLocal.month}/${dateLocal.day}/${dateLocal.year}@${(dateLocal.hour % 12 == 0 ? 12 : dateLocal.hour % 12).toString().padLeft(2, '0')}:${dateLocal.minute.toString().padLeft(2, '0')} ${dateLocal.hour >= 12 ? 'pm' : 'am'}';
}

// String formatPrice(String number) {
//   if (number == number.roundToDouble()) {
//     return number.toStringAsFixed(0);
//   } else {
//     return number.toString();
//   }
// }

// String formatPrice(String price) {
//   double priceValue = double.parse(price);
//
//   if (priceValue == priceValue.roundToDouble()) {
//     return priceValue.toInt().toString();
//   } else {
//     return priceValue.toStringAsFixed(2);
//   }
// }

String formatPrice(num? price) {
  if (price == null) {
    return '0';
  }

  if (price == price.roundToDouble()) {
    return price.toInt().toString();
  } else {
    return price.toStringAsFixed(2);
  }
}