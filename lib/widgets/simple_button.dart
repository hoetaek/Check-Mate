import 'package:check_mate/constants.dart';
import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  SimpleButton({this.onPressed, this.color, this.title});
  final Function onPressed;
  final Color color;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return MaterialButton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: title ??
            Text(
              '확인',
              style: theme.textTheme.button
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
            ),
      ),
      onPressed: onPressed,
      color: color == null ? color : kMainColor,
      splashColor: theme.accentColor,
      elevation: 4.0,
      highlightElevation: 2.0,
      shape: StadiumBorder(),
    );
  }
}
