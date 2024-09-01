import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/trading_provider.dart';
import '../widgets/trading_list_tile.dart';

class TradingHomePage extends StatefulWidget {
  const TradingHomePage({super.key});

  @override
  TradingHomePageState createState() => TradingHomePageState();
}

class TradingHomePageState extends State<TradingHomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TradingProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Trading Instruments')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter the symbol like BINANCE:BTCUSDT',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final symbol = _searchController.text.trim();
                    if (symbol.isNotEmpty && !provider.isSymbolAdded(symbol)) {
                      provider.addInstrument(symbol);
                      _searchController.clear();
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<TradingProvider>(
              builder: (context, provider, child) {
                return ListView.builder(
                  itemCount: provider.instruments.length,
                  itemBuilder: (context, index) {
                    final instrument = provider.instruments[index];
                    return TradingListTile(instrument: instrument);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
