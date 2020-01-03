import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventTile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final DateTime date;
  final double size;
  final Color color;
  EventTile(
      {this.title,
      this.subtitle,
      this.date,
      @required this.size,
      @required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
            top: Divider.createBorderSide(context),
            bottom: Divider.createBorderSide(context)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: size),
                child: FittedBox(
                    child: Column(
                  children: <Widget>[
                    Text(
                      DateFormat('EEEE').format(date).substring(0, 3),
//                      style: TextStyle(color: color),
                    ),
                    CircleAvatar(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    )
                  ],
                ))),
          ),
          Expanded(
            flex: 6,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: size),
              child: Container(
                decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(6))),
                child: Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
//                      SizedBox(height: kTilePadding),
                      title,
                      SizedBox(height: 2),
                      subtitle,
//                      SizedBox(height: kTilePadding),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
