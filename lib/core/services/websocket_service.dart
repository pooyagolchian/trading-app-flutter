import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class IWebSocketService {
  Stream<Map<String, dynamic>> get priceStream;
  void subscribe(String symbol);
  void unsubscribe(String symbol);
  void dispose();
}

class WebSocketService implements IWebSocketService {
  final WebSocketChannel _channel;

  WebSocketService({WebSocketChannel? channel})
      : _channel = channel ?? WebSocketChannel.connect(_buildUri()) {
    _logConnectionStatus();
  }

  static Uri _buildUri() {
    final apiKey = dotenv.env['FINNHUB_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('API key is missing or not found in the .env file.');
    }
    return Uri.parse('wss://ws.finnhub.io/?token=$apiKey');
  }

  @override
  Stream<Map<String, dynamic>> get priceStream => _channel.stream.map((event) {
    _logReceivedData(event);
    return json.decode(event) as Map<String, dynamic>;
  }).handleError(_logError);

  @override
  void subscribe(String symbol) {
    _sendMessage({'type': 'subscribe', 'symbol': symbol});
    print('Subscribed to $symbol');
  }

  @override
  void unsubscribe(String symbol) {
    _sendMessage({'type': 'unsubscribe', 'symbol': symbol});
    print('Unsubscribed from $symbol');
  }

  void _sendMessage(Map<String, dynamic> message) {
    _channel.sink.add(json.encode(message));
  }

  @override
  void dispose() {
    _channel.sink.close();
    print('WebSocket connection closed');
  }

  void _logConnectionStatus() {
    print('WebSocket connection established');
  }

  void _logReceivedData(String data) {
    print('Data received: $data');
  }

  void _logError(Object error) {
    print('WebSocket error: $error');
  }
}
