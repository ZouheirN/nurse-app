import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalizationBox {
  static final _box = Hive.box('localizationBox');

  static void saveLocale(String locale) {
    _box.put('locale', locale);
  }

  static Locale? getLocale() {
    final locale = _box.get('locale');

    if (locale == null) {
      return null; // Return null if no locale is saved
    }

    return Locale(locale as String);
  }

  static ValueListenable<Box> getLocaleNotifier() {
    return _box.listenable(keys: ['locale']);
  }
}
