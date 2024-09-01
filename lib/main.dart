import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/trading/data/trading_provider.dart';
import 'features/trading/presentation/pages/trading_home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TradingProvider()),
      ],
      child: const TradingApp(),
    ),
  );
}

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TradingHomePage(),
    );
  }
}
