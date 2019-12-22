import 'dart:math';

import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  SimpleCard({@required this.children, this.color});
  final List<Widget> children;
  final Color color;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final cardWidth = min(deviceSize.width * 0.75, 360.0);
    const cardPadding = 16.0;
    return Card(
      color: color,
      child: Container(
          padding: EdgeInsets.only(
            left: cardPadding,
            top: cardPadding + 10.0,
            right: cardPadding,
            bottom: cardPadding,
          ),
          width: cardWidth,
          alignment: Alignment.center,
          child: Column(
            children: children,
          )),
    );
  }
}
