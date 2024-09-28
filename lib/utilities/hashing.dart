import 'dart:convert';

import 'package:crypto/crypto.dart';

String encryptString(String value) =>
    base64UrlEncode(utf8.encode(sha256.convert(utf8.encode(value)).toString()));
