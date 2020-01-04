import 'package:check_mate/constants.dart';
import 'package:check_mate/widgets/simple_card.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatelessWidget {
  final int index;
  final Function onChange;
  ColorPicker({@required this.index, @required this.onChange});
  List<Widget> _children() {
    final List<int> colorsRange = List<int>.generate(kColors.length, (i) => i);
    return colorsRange
        .map((i) => GestureDetector(
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: kColors[i],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: index == i
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : null,
              ),
              onTap: () {
                onChange(i);
              },
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = _children();
    return SimpleCard(
        cardPadding: EdgeInsets.only(
          left: 9,
          top: 16,
          right: 9,
          bottom: 16,
        ),
        color: Color.fromRGBO(234, 213, 242, 0.4),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children.sublist(0, 9),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children.sublist(9, 18),
          ),
        ]);
  }
}
