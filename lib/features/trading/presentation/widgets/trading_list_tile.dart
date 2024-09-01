import 'package:flutter/material.dart';
import '../../../../core/models/trading_instrument.dart';

class TradingListTile extends StatelessWidget {
  final TradingInstrument instrument;
  const TradingListTile({super.key, required this.instrument});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(instrument.symbol),
      trailing: Text(
        instrument.price.toStringAsFixed(2),
        style: TextStyle(
          color: instrument.isUp ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
