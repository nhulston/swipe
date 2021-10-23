import 'package:flutter/material.dart';
import 'package:swipe/Services/stocks.dart';
import 'package:swipe/Style/radiant_gradient_mask.dart';
import 'Style/portfolio.dart';
import 'cards.dart';
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
  @override
  Widget build(BuildContext context) {
    StockServices().fetchStockData();

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: MyNavBar(notifyParent: () {setState(() {});}),
      appBar: const MyAppBar(),
      body: Center(
        child: MyNavBarState.bottomNavIndex == 0 ? const Cards() : const Portfolio(),
      ),
    );
  }
}
