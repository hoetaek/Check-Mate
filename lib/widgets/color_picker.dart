import 'package:check_mate/constants.dart';
import 'package:check_mate/widgets/simple_card.dart';
import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final initialIndex;
  ColorPicker({Key key, this.initialIndex}) : super(key: key);
  @override
  ColorPickerState createState() => ColorPickerState();
}

class ColorPickerState extends State<ColorPicker> {
  int _index;
  int get colorIndex => _index;
  final List<int> colorsRange = List<int>.generate(kColors.length, (i) => i);
  @override
  void initState() {
    setState(() {
      _index = widget.initialIndex == null ? 0 : widget.initialIndex;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleCard(
        children: colorsRange
            .map((i) => GestureDetector(
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: kColors[i],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
//          border: Border.all(width: 2, color: Colors.white),
                    ),
                    child: _index == i
                        ? Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  onTap: () {
                    setState(() {
                      _index = i;
                    });
                  },
                ))
            .toList());
  }
}
