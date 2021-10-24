import 'package:flutter/material.dart';
import 'package:swipe/add_watchlist_card.dart';
import 'package:swipe/card.dart';
import 'package:swipe/models/portfolio.dart';
import 'package:swipe/services/stocks.dart';
import 'package:swipe/style/app_colors.dart';
import 'package:swipe/style/radiant_gradient_mask.dart';
import 'package:swipe/watchlist_page.dart';
//import 'style/portfolio.dart';
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
    return const MaterialApp(
      title: '\$wipe',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<AssetCard> stocks = [];
  Function? watchlistCallback;
  static int? currentlyViewedIndex;
  getStocks() async {
    for (int i = 0; i < 10; i++) {
      Stock s = await getStock();
      AssetCard card = AssetCard(asset: s, index: i,);
      stocks.add(card);
      setState(() {
      });
      if (SwipePageState.stateRef != null) {
        SwipePageState.stateRef!.updateState();
      }
    }
  }

  Future<Stock> getStock() async {
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
    super.initState();
    getStocks();
    currentlyViewedIndex = 0;
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
            ? stocks.isEmpty ?
              const Text("Loading...")
              : SwipePage(cards: stocks,)
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
          await Portfolio.addToPortfolio(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height, "AAPL");
          setState(() {});
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
