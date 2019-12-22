import 'package:check_mate/constants.dart';
import 'package:flutter/material.dart';

class CheckMateLogoAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            child: Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/check_logo.png',
                width: 50,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Hero(
              tag: 'title',
              child: Text(
                'Check Mate',
                style: Theme.of(context)
                    .textTheme
                    .display2
                    .copyWith(color: kEmphasisMainColor),
              )),
          Flexible(
            child: Container(
              width: 60,
            ),
          ),
        ],
      ),
//      actions: <Widget>[
//        isLogo
//            ? Container()
//            : IconButton(
//                icon: Icon(
//                  Icons.people,
//                  size: 40,
//                ),
//                onPressed: () {},
//              ),
//      ],
      backgroundColor: kMainColor,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70);
}
