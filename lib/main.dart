import 'package:flutter/material.dart';
import 'package:swipe/services/stocks.dart';
import 'package:swipe/style/radiant_gradient_mask.dart';
import 'style/portfolio.dart';
import 'cards.dart';
import 'package:swipe/models/stock.dart';
import 'my_app_bar.dart';
import 'my_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '\$wipe',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getStocks() async {
    String symbol = await StockServices.getRandomSymbol();
    print(symbol);
    try {
      await StockServices.fetchStock(symbol);
    } catch (e) {
      getStocks();
    }
  }

  @override
  Widget build(BuildContext context) {
    getStocks();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: MyNavBar(notifyParent: () {
        setState(() {});
      }),
      appBar: const MyAppBar(),
      body: Center(
        child: MyNavBarState.bottomNavIndex == 0
            ? const Cards()
            : const Portfolio(),
      ),
    );
  }
}
