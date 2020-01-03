import 'package:flutter/material.dart';

class SimpleCard extends StatelessWidget {
  SimpleCard({@required this.children, this.color});
  final List<Widget> children;
  final Color color;
  @override
  Widget build(BuildContext context) {
    const cardPadding = 16.0;
    return Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        padding: EdgeInsets.only(
          left: cardPadding - 7,
          top: cardPadding,
          right: cardPadding - 7,
          bottom: cardPadding,
        ),
        alignment: Alignment.center,
        child: Column(
          children: children.length <= 8
              ? <Widget>[
                  Row(
                    children: children,
                  )
                ]
              : <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: children.sublist(0, 9),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: children.sublist(9, 18),
                  ),
                ],
        ));
  }
}
