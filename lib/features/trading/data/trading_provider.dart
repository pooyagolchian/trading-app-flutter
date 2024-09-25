import 'package:flutter/material.dart';
import '../../../core/models/trading_instrument.dart';
import '../../../core/services/websocket_service.dart';

class TradingProvider with ChangeNotifier {
  final List<TradingInstrument> _instruments = [];
  final IWebSocketService _webSocketService;

  TradingProvider({IWebSocketService? webSocketService})
      : _webSocketService = webSocketService ?? WebSocketService() {
    _listenToPriceStream();
  }

  List<TradingInstrument> get instruments => List.unmodifiable(_instruments);

  void addInstrument(String symbol) {
    if (!isSymbolAdded(symbol)) {
      final instrument = TradingInstrument(symbol: symbol, price: 0.0);
      _instruments.add(instrument);
      _webSocketService.subscribe(symbol);
      notifyListeners();
    }
  }

  bool isSymbolAdded(String symbol) {
    return _instruments.any((instrument) => instrument.symbol == symbol);
  }

  void _updatePrice(String symbol, double newPrice) {
    final instrument = _instruments.firstWhere(
          (element) => element.symbol == symbol,
      orElse: () => throw Exception('Instrument with symbol $symbol not found.'),
    );
    instrument.updatePrice(newPrice);
    notifyListeners();
  }

  void _listenToPriceStream() {
    _webSocketService.priceStream.listen((data) {
      if (data['type'] == 'trade') {
        for (var tradeData in data['data']) {
          final symbol = tradeData['s'];
          final price = tradeData['p'];
          final parsedPrice = _parsePrice(price);
          print('Symbol: $symbol, Price: $parsedPrice');
          _updatePrice(symbol, parsedPrice);
        }
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  double _parsePrice(dynamic price) {
    if (price is int) {
      return price.toDouble();
    } else if (price is double) {
      return double.parse(price.toStringAsFixed(2));
    } else {
      final parsed = double.tryParse(price.toString()) ?? 0.0;
      return double.parse(parsed.toStringAsFixed(2));
    }
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }
}
