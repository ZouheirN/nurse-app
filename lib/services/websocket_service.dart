import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http; // 👈 add this
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';

class WebSocketService {
  static WebSocketChannel? _channel;
  static bool _isConnected = false;
  static String? _socketId;                       // 👈 used for auth step
  static final Map<String, Function(dynamic)> _channelCallbacks = {};
  static final Map<String, List<String>> _channelEvents = {};

  static const String _appKey = '343b7b28924b70e72293'; // 👈 your Pusher key
  static const String _pusherWsUrl =
      'wss://ws-eu.pusher.com/app/$_appKey?protocol=7&client=flutter&version=1.0';

  static Future<void> initialize() async {
    if (_channel != null && _isConnected) return;

    try {
      final token = await UserToken.getToken();
      if (token == null) {
        logger.e('❌ No token found. Please login first.');
        return;
      }

      logger.i('🔌 Connecting to Pusher…');
      logger.i('🔗 URL: $_pusherWsUrl');

      _channel = WebSocketChannel.connect(Uri.parse(_pusherWsUrl));

      _channel!.stream.listen(
            (message) => _handleMessage(message),
        onError: (error) {
          logger.e('❌ WebSocket error: $error');
          _isConnected = false;
        },
        onDone: () {
          logger.w('🔌 Disconnected from Pusher');
          _isConnected = false;
          _socketId = null;
        },
      );
    } catch (e) {
      logger.e('❌ WebSocket initialization error: $e');
    }
  }

  static void _handleMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message);
      final event = decoded['event'];
      final data = decoded['data'];

      logger.d('📩 Incoming event: $event');

      if (event == 'pusher:connection_established') {
        final payload = jsonDecode(data);
        _socketId = payload['socket_id'];   // 👈 capture socket_id
        _isConnected = true;
        logger.i('✅ Connected | socket_id: $_socketId');
      } else if (event == 'pusher_internal:subscription_succeeded') {
        logger.i('✅ Channel subscription succeeded: $data');
      } else if (event == 'pusher:error') {
        logger.e('⚠ Pusher error: $data');
      } else {
        _dispatchEvent(event, data);
      }
    } catch (e) {
      logger.w('⚠ Non-JSON message: $message');
    }
  }

  static void _dispatchEvent(String eventName, dynamic data) {
    for (final entry in _channelCallbacks.entries) {
      final channelName = entry.key;
      final callback = entry.value;
      if (_channelEvents[channelName]?.contains(eventName) == true) {
        callback({'eventName': eventName, 'data': data});
      }
    }
  }

  // 👇 NEW: ask Laravel for the 'key:signature' auth
  static Future<String?> _fetchPusherAuth({
    required String channelName,
    required String socketId,
  }) async {
    try {
      final token = await UserToken.getToken();
      final uri = Uri.parse('${Consts.host}/broadcasting/auth');

      // Laravel expects form or JSON. Either works; we'll send form-urlencoded:
      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'channel_name': channelName,
          'socket_id': socketId,
        },
      );

      logger.d('🔐 Auth status: ${response.statusCode} body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['auth'] as String?; // "key:signature"
      } else if (response.statusCode == 401) {
        logger.e('❌ Auth 401: invalid token/unauthenticated');
      } else if (response.statusCode == 403) {
        logger.e('❌ Auth 403: not authorized for $channelName');
      } else {
        logger.e('❌ Auth failed: HTTP ${response.statusCode}');
      }
    } catch (e) {
      logger.e('❌ Auth request error: $e');
    }
    return null;
  }

  static Future<void> subscribe(String channelName, Function(dynamic) callback) async {
    logger.i('📡 Subscribe → $channelName');

    if (!_isConnected || _socketId == null) {
      logger.i('⏳ Not connected yet, initializing…');
      await initialize();

      // Wait up to ~10s for connection/socket_id
      for (var i = 0; i < 20 && (!_isConnected || _socketId == null); i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        logger.d('⏳ Waiting for connection/socket_id… attempt ${i + 1}');
      }
      if (!_isConnected || _socketId == null) {
        logger.e('❌ No connection/socket_id — cannot subscribe.');
        return;
      }
    }

    _channelCallbacks[channelName] = callback;
    _channelEvents[channelName] = ['message.created', 'thread.closed'];

    // 👇 get the 'key:signature' from Laravel
    final auth = await _fetchPusherAuth(
      channelName: channelName,
      socketId: _socketId!,
    );
    if (auth == null) {
      logger.e('❌ No auth signature returned — subscription aborted.');
      return;
    }

    // 👇 now send the real subscribe payload
    final payload = {
      "event": "pusher:subscribe",
      "data": {
        "channel": channelName,
        "auth": auth, // "key:signature"
        // "channel_data": "{\"user_id\":123}" // only for presence channels
      }
    };

    _channel!.sink.add(jsonEncode(payload));
    logger.i('✅ Sent subscription for $channelName');
  }

  static void unsubscribe(String channelName) {
    if (!_isConnected || _channel == null) return;

    final payload = {
      "event": "pusher:unsubscribe",
      "data": {"channel": channelName}
    };
    _channel!.sink.add(jsonEncode(payload));

    _channelCallbacks.remove(channelName);
    _channelEvents.remove(channelName);

    logger.i('📴 Unsubscribed: $channelName');
  }

  static void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    _socketId = null;
    _channelCallbacks.clear();
    _channelEvents.clear();
    logger.w('🔌 WebSocket disconnected.');
  }

  static bool get isConnected => _isConnected;
}