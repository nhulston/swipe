import 'package:flutter/material.dart';
import 'package:swipe/style/app_colors.dart';

class WatchlistPage extends StatefulWidget {
  final List<Widget> items;
  WatchlistPage(this.items, {Key? key}) : super(key: key);

  @override
  WatchlistPageState createState() {
    return WatchlistPageState();
  }
}

class WatchlistPageState extends State<WatchlistPage> {

  static WatchlistPageState? stateReference;

  updateState() {
    this.setState(() {
      print('Setting state');
    });
  }

  @override
  void initState() {
    stateReference = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.only(left: screenWidth / 17, right: screenWidth / 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight / 40),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.almostWhite,
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13, 10, 10, 10),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    size: screenWidth / 13,
                    color: AppColors.red,
                  ),
                  const SizedBox(width: 10),
                  Text(
                      "Search 50 cryptos",
                      style: TextStyle(
                        color: AppColors.lightGray,
                        fontSize: screenWidth / 25,
                      )
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenHeight / 30),
          Text(
            'Your Crypto Watchlist',
            style: TextStyle(
              color: AppColors.red,
              fontSize: screenWidth / 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight / 50),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: widget.items,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
