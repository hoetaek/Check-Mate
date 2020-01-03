import 'package:check_mate/constants.dart';
import 'package:flutter/material.dart';

class FriendListTile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget userImage;
  final Widget trailing;
  FriendListTile({this.title, this.subtitle, this.userImage, this.trailing});

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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: userImage,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: kTilePadding),
                title,
                SizedBox(height: kTitleTilePadding),
                subtitle ?? Container(),
                SizedBox(height: kTilePadding),
              ],
            ),
          ),
          trailing ?? Container(),
        ],
      ),
    );
  }
}
