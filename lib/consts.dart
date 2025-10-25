import 'package:flutter_dotenv/flutter_dotenv.dart';

class Consts {
  static String get host => dotenv.env['HOST'] ?? '';
  static String get imgbbApiKey => dotenv.env['IMGBB_API_KEY'] ?? '';
  static String get oneSignalAppId => dotenv.env['ONE_SIGNAL_APP_ID'] ?? '';
  static String get oneSignalApiKey => dotenv.env['ONE_SIGNAL_API_KEY'] ?? '';
  static String get streamApiKey => dotenv.env['STREAM_API_KEY'] ?? '';
  static String get iosPushProviderName => dotenv.env['IOS_PUSH_PROVIDER_NAME'] ?? '';
  static String get androidPushProviderName => dotenv.env['ANDROID_PUSH_PROVIDER_NAME'] ?? '';
  static String get reverbHost => dotenv.env['REVERB_HOST'] ?? '';
  static int get reverbPort => int.tryParse(dotenv.env['REVERB_PORT'] ?? '') ?? 8080;
}