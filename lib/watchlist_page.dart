import 'package:flutter/material.dart';
import 'package:swipe/style/app_colors.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({Key? key}) : super(key: key);

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> {
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
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: screenHeight / 50),
                // Example item
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.almostWhite,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.remove_red_eye,
                            color: AppColors.blackText,
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: screenWidth / 2.35,
                            child: Text(
                              "Bitcoin" + " " + "(BTC)",
                              style: TextStyle(
                                fontSize: screenHeight / 45,
                                color: AppColors.blackText,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "\$60,000",
                            style: TextStyle(
                              fontSize: screenHeight / 60,
                              color: AppColors.blackText,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "+0.98%",
                            style: TextStyle(
                              fontSize: screenHeight / 60,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
