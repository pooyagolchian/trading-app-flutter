class TradingInstrument {
  final String symbol;
  double price;
  bool isUp;

  TradingInstrument({required this.symbol, required this.price, this.isUp = false});

  void updatePrice(double newPrice) {
    isUp = newPrice > price;
    price = newPrice;
  }
}
