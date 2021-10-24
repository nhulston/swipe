import 'package:flutter/material.dart';
import 'package:swipe/card.dart';
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
  List<AssetCard> stocks = [];


  getStocks() async {
    for (int i = 0; i < 10; i++) {
      Stock s = await getStock();
      AssetCard card = AssetCard(asset: s);
      stocks.add(card);
      setState(() {
        stocks = stocks;
      });
    }
  }

  Future<Stock> getStock() async {
    String symbol = await StockServices.getRandomSymbol();
    print(symbol);
    try {
      return await StockServices.fetchStock(symbol);
    } catch (e) {
      return getStocks();
    }

}

  @override
  void initState() {
    getStocks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: MyNavBar(notifyParent: () {
        setState(() {});
      }),
      appBar: const MyAppBar(),
      body: Center(
        child: MyNavBarState.bottomNavIndex == 0
            ? stocks.isEmpty ?
              Text("Loading...")
              : Cards(cards: stocks,)
            : const Portfolio(),
      ),
    );
  }
}
