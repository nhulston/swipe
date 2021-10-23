import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

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

List<Widget> cards = List.generate(
  colors.length,
      (int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors[index],
      ),
      child: Text(
        '${index + 1}',
        style: TextStyle(fontSize: 100.0, color: Colors.white),
      ),
    );
  },
);

class Cards extends StatefulWidget {
  const Cards({Key? key}) : super(key: key);

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
      cards: cards,
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
