import 'package:flutter/material.dart';
import 'package:swipe/Services/stocks.dart';
import 'package:swipe/Style/app_colors.dart';
import 'package:swipe/Style/radiant_gradient_mask.dart';
import 'Style/portfolio.dart';
import 'cards.dart';

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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    StockServices().fetchStockData();
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image(
              height: screenHeight / 30,
              image: AssetImage(_selectedIndex == 0 ? 'assets/s.png' : 'assets/s_gray.png'),
            ),
            title: const SizedBox.shrink(),
          ),
          BottomNavigationBarItem(
            icon: _selectedIndex == 0 ? Icon(
              Icons.grid_view,
              size: screenHeight / 30,
            ) : RadiantGradientMask(
                child: Icon(
                  Icons.grid_view,
                  size: screenHeight / 30,
                )
            ),
            title: const SizedBox.shrink(),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              onPressed: () {

              },
              icon: RadiantGradientMask(
                child: Icon(
                  Icons.account_circle,
                  color: AppColors.red,
                  size: screenWidth / 10,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(top: screenHeight / 300),
              child: Image(
                height: screenWidth / 5,
                image: const AssetImage('assets/logo.png'),
              ),
            ),
            SizedBox(width: screenWidth / 11),
            const Spacer(),
          ],
        ),
      ),
      body: Center(
        child: _selectedIndex == 0 ? const Cards() : const Portfolio(),
      ),
    );
  }
}
