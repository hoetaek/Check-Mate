import 'package:check_mate/constants.dart';
import 'package:flutter/material.dart';

class CheckboxLeadingTile extends StatelessWidget {
  const CheckboxLeadingTile(
      {this.title,
      this.subtitle,
      this.value,
      this.onChanged,
      this.activeColor,
      this.idx});

  final Text title;
  final Text subtitle;
  final bool value;
  final Function onChanged;
  final Color activeColor;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () =>
          Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Container();
//                EditTodoItemScreen(idx: idx);
      })),
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        children: <Widget>[
          Checkbox(
            value: value,
            onChanged: (bool newValue) {
              onChanged(newValue);
            },
            activeColor: activeColor,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: kTilePadding),
              title,
              SizedBox(height: kTitleTilePadding),
              subtitle,
              SizedBox(height: kTilePadding),
            ],
          ),
        ],
      ),
    );
  }
}
