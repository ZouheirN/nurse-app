import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nurse_app/consts.dart';
import 'package:nurse_app/main.dart';
import 'package:nurse_app/services/user_token.dart';

class WebSocketService {
  static WebSocketChannel? _channel;
  static bool _isConnected = false;
  static String? _socketId;
  static final Map<String, Function(dynamic)> _channelCallbacks = {};
  static final Map<String, List<String>> _channelEvents = {};

  static Future<void> initialize() async {
    if (_channel != null && _isConnected) return;

    try {
      final token = await UserToken.getToken();
      if (token == null) {
        logger.e('❌ No token found. Please login first.');
        return;
      }

      const appKey = 'zrjhzajatsf5exsgvlgw'; // your Reverb app key from .env

      final wsUrl =
          'wss://ws-eu.pusher.com/app/$appKey?protocol=7&client=flutter&version=1.0';

      logger.i('🔌 Connecting to Reverb...');
      logger.i('🔗 URL: $wsUrl');
      logger.i('🔑 Token (truncated): ${token.substring(0, 25)}...');

      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));

      _channel!.stream.listen(
        (message) {
          _handleMessage(message);
        },
        onError: (error) {
          logger.e('❌ WebSocket error: $error');
          _isConnected = false;
        },
        onDone: () {
          logger.w('🔌 Disconnected from Reverb');
          _isConnected = false;
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
        _socketId = payload['socket_id'];
        _isConnected = true;
        logger.i('✅ Connected to Reverb | Socket ID: $_socketId');
      } else if (event == 'pusher_internal:subscription_succeeded') {
        logger.i('✅ Channel subscription succeeded');
      } else if (event == 'pusher:error') {
        logger.e('⚠️ Pusher error: $data');
      } else {
        // normal app-level events
        _dispatchEvent(event, data);
      }
    } catch (e) {
      logger.w('⚠️ Non-JSON message: $message');
    }
  }

  static void _dispatchEvent(String eventName, dynamic data) {
    logger.d('🎯 Dispatching $eventName');
    for (final entry in _channelCallbacks.entries) {
      final channelName = entry.key;
      final callback = entry.value;
      if (_channelEvents[channelName]?.contains(eventName) == true) {
        callback({'eventName': eventName, 'data': data});
      }
    }
  }

  static Future<void> subscribe(String channelName, Function(dynamic) callback) async {
    logger.i('📡 Attempting to subscribe to: $channelName');

    if (!_isConnected) {
      logger.i('⏳ Not connected, initializing...');
      await initialize();

      int attempts = 0;
      while (!_isConnected && attempts < 20) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
        logger.d('⏳ Waiting for connection... attempt $attempts');
      }

      if (!_isConnected) {
        logger.e('❌ Failed to connect after 10 seconds');
        return;
      }
    }

    _channelCallbacks[channelName] = callback;
    _channelEvents[channelName] = ['message.created', 'thread.closed'];

    final token = await UserToken.getToken();

    final subscribePayload = {
      "event": "pusher:subscribe",
      "data": {
        "auth": "Bearer $token",
        "channel": channelName,
      }
    };

    _channel!.sink.add(jsonEncode(subscribePayload));

    logger.i('📡 Subscribed to channel: $channelName');
  }

  static void unsubscribe(String channelName) {
    if (!_isConnected || _channel == null) return;

    final unsubscribePayload = {
      "event": "pusher:unsubscribe",
      "data": {"channel": channelName}
    };

    _channel!.sink.add(jsonEncode(unsubscribePayload));
    _channelCallbacks.remove(channelName);
    _channelEvents.remove(channelName);

    logger.i('📴 Unsubscribed from channel: $channelName');
  }

  static void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    _channelCallbacks.clear();
    _channelEvents.clear();
    logger.w('🔌 Reverb Socket disconnected.');
  }

  static bool get isConnected => _isConnected;
}
