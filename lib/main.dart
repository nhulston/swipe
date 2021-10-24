import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:swipe/add_watchlist_card.dart';
import 'package:swipe/card.dart';
import 'package:swipe/models/portfolio.dart';
import 'package:swipe/services/stocks.dart';
import 'package:swipe/style/app_colors.dart';
import 'package:swipe/watchlist_page.dart';
import 'swipe_page.dart';
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
    return MaterialApp(
      builder: OneContext().builder,
      navigatorKey: OneContext().navigator.key,
      title: '\$wipe',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static List<AssetCard> stocks = [];
  Function? watchlistCallback;
  static int? currentlyViewedIndex;
  static MyHomePageState? stateRef;

  static getStocks() async {
    print("GETTING STOCKS");
    int offset = stocks.length;
    for (int i = 0; i < 10; i++) {
      Stock s = await getStock();
      AssetCard card = AssetCard(asset: s, index: i + offset,);
      stocks.add(card);
      stateRef!.setState(() {
      });
      if (SwipePageState.stateRef != null) {
        SwipePageState.stateRef!.updateState();
      }
    }
  }

  static Future<Stock> getStock() async {
    String symbol = await StockServices.getRandomSymbol();
    print(symbol);
    try {
      return await StockServices.fetchStock(symbol);
    } catch (e) {
      return getStock();
    }
}

  @override
  void initState() {
    getStocks();
    currentlyViewedIndex = 0;
    super.initState();
    stateRef = this;
  }

  @override
  Widget build(BuildContext context) {
    WatchlistPage watchlistPage = WatchlistPage(Portfolio.items);
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: MyNavBar(notifyParent: () {
        setState(() {});
      }),
      appBar: const MyAppBar(),
      body: Center(
        child: MyNavBarState.bottomNavIndex == 0
          ? (stocks.isEmpty ?
            const Text("Loading...")
            : SwipePage(cards: stocks))
          : watchlistPage,
      ),
      floatingActionButton: MyNavBarState.bottomNavIndex == 0 ? null : FloatingActionButton(
        backgroundColor: AppColors.red,
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddWatchlistCard();
            },
          );
          setState(() {});
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
