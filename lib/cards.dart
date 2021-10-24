import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
import 'package:swipe/card.dart';

List<Color> colors = [
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.orange,
  Colors.pink,
  Colors.amber,
  Colors.cyan,
  Colors.purple,
  Colors.brown,
  Colors.teal,
];

class Cards extends StatefulWidget {
  final List<AssetCard> cards;
  Cards({Key? key, required this.cards}) : super(key: key);

  @override
  _CardsState createState() => _CardsState();
}

class _CardsState extends State<Cards> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return TCard(
      size: Size(screenWidth, screenHeight),
      lockYAxis: true,
      cards: widget.cards,
      onForward: (int x, SwipInfo info) {
        log('$x');
        log('${info.cardIndex}');
      },
      onBack: (int x, SwipInfo info) {
        log('$x');
        log('${info.cardIndex}');
      },
    );
  }
}
