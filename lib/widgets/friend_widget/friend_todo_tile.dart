import 'package:check_mate/constants.dart';
import 'package:flutter/material.dart';

class FriendTodoTile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final bool checked;
  FriendTodoTile({this.title, this.subtitle, this.checked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          value: checked,
          onChanged: null,
          activeColor: kMainColor,
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
    );
  }
}
