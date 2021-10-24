import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swipe/elements/tinder_swipe/tinder_swipe.dart';
import 'package:swipe/card.dart';

import 'elements/tinder_swipe/swipe_info.dart';

class SwipePage extends StatefulWidget {
  final List<AssetCard> cards;
  const SwipePage({Key? key, required this.cards}) : super(key: key);

  @override
  _SwipePageState createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    TinderSwipe build = TinderSwipe(
      size: Size(screenWidth, screenHeight),
      cards: widget.cards,
      onForward: (int x, SwipeInfo info) {
        log('$x');
        log('${info.cardIndex}');
      },
      onBack: (int x, SwipeInfo info) {
        log('$x');
        log('${info.cardIndex}');
      },
    );
    print("rebuilding: ${build.cards}");
    return build;
  }

}
