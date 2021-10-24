import 'package:flutter/material.dart';
import 'package:swipe/models/portfolio.dart';
import 'package:swipe/style/app_colors.dart';
import 'package:swipe/watchlist_page.dart';

class AddWatchlistCard extends StatefulWidget {
  AddWatchlistCard({Key? key}) : super(key: key);

  @override
  _AddWatchlistCardState createState() => _AddWatchlistCardState();
}

class _AddWatchlistCardState extends State<AddWatchlistCard> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool loading = false;

    return Align(
      child: SizedBox(
        height: screenHeight / 3,
        width: screenWidth / 1.2,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(height: screenHeight / 30),
                Text(
                  "Add Crypto to Watchlist",
                  style: TextStyle(
                    color: AppColors.blackText,
                    fontSize: screenWidth / 20,
                  ),
                ),
                SizedBox(height: screenHeight / 30),
                SizedBox(
                  width: screenWidth / 2,
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(
                      color: AppColors.blackText,
                      fontSize: 14
                    ),
                    decoration: const InputDecoration(
                      hintText: "Enter a ticker (e.g. BTC)",
                      isDense: true,
                      focusedBorder: OutlineInputBorder( // Selected border
                        borderSide: BorderSide(color: AppColors.red, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder: OutlineInputBorder( // Unselected border
                        borderSide: BorderSide(color: AppColors.darkGray, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    bool result = await Portfolio.addToPortfolio(screenWidth, screenHeight, controller.text);
                    print('adding to watchlist: $result');
                    if (result) {
                      print('adding to watchlist yes');
                      WatchlistPageState.stateReference!.updateState();
                      Navigator.of(context).pop();
                    } else {
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  child: loading ? const CircularProgressIndicator(
                    color: Colors.white,
                  ) : Text(
                    "Done",
                    style: TextStyle(
                      fontSize: screenHeight / 50,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight / 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
