import 'dart:ffi';

import 'package:flutter/material.dart';
import '../../../core/models/trading_instrument.dart';
import '../../../core/services/websocket_service.dart';

class TradingProvider with ChangeNotifier {
  final List<TradingInstrument> _instruments = [];
  final IWebSocketService _webSocketService;

  TradingProvider({IWebSocketService? webSocketService})
      : _webSocketService = webSocketService ?? WebSocketService() {
    listenToPriceStream();
  }

  List<TradingInstrument> get instruments => _instruments;

  void addInstrument(String symbol) {
    final instrument = TradingInstrument(symbol: symbol, price: 0.0);
    _instruments.add(instrument);
    _webSocketService.subscribe(symbol);
    notifyListeners();
  }

  bool isSymbolAdded(String symbol) {
    return _instruments.any((instrument) => instrument.symbol == symbol);
  }

  void updatePrice(String symbol, double newPrice) {
    try {
      final instrument =
          _instruments.firstWhere((element) => element.symbol == symbol);
      instrument.updatePrice(newPrice);
      notifyListeners();
    } catch (e) {
      print('Instrument with symbol $symbol not found.');
    }
  }

  void listenToPriceStream() {
    _webSocketService.priceStream.listen((data) {
      if (data['type'] == 'trade') {
        for (var tradeData in data['data']) {
          final symbol = tradeData['s'];
          final dynamic price = tradeData['p'];
          final double parsedPrice;
          if ((price is Double)) {
            parsedPrice = price as double;
            print(parsedPrice);
          } else {
            parsedPrice = (price is double)
                ? price.toDouble()
                : double.tryParse(price.toString()) ?? 0.0;
          }
          final double formattedPrice =
              double.parse(parsedPrice.toStringAsFixed(2));
          print('Symbol: $symbol, Price: $formattedPrice');
          updatePrice(symbol, formattedPrice);
        }
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    });
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    super.dispose();
  }
}
