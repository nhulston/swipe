import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe/elements/tinder_swipe/tinder_swipe.dart';
import 'package:swipe/card.dart';

import 'elements/tinder_swipe/swipe_info.dart';

class SwipePage extends StatefulWidget {
  List<AssetCard> cards;
  SwipePage({Key? key, required this.cards}) : super(key: key);

  @override
  SwipePageState createState() => SwipePageState();
}

class SwipePageState extends State<SwipePage> {

  static SwipePageState? stateRef;

  updateState() {
    setState(() {
      print("setting state of swipe page");
    });
  }

  @override
  void initState() {
    stateRef = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TinderSwipe build = TinderSwipe(
      size: Size(screenWidth, screenHeight),
      cards: widget.cards,
      onForward: (int x, SwipeInfo info) {
        setState(() {
          // widget.cards.removeAt(0);
        });
        log('$x');
        log('${info.cardIndex}');
      },
      onBack: (int x, SwipeInfo info) {
        setState(() {
          // widget.cards.removeAt(0);
        });
        log('$x');
        log('${info.cardIndex}');
      },
    );
    // print("rebuilding: ${build.cards}");
    return build;
  }

}
