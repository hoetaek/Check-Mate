import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  SimpleCard({@required this.children, this.color, @required this.cardPadding});
  final List<Widget> children;
  final Color color;
  final EdgeInsets cardPadding;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        padding: cardPadding,
        alignment: Alignment.center,
        child: Column(
          children: children,
        ));
  }
}
