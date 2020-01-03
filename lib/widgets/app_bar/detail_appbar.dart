import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 140;
  final TodoItem todoItem;
  DetailAppBar({this.todoItem});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: BoxDecoration(color: kMainColor, boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 3.0, spreadRadius: 0.3)
            ]),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            '${todoItem.title}',
                            style: GoogleTextStyle.tileTitleTextStyle.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.doorOpen,
                              color: kEmphasisMainColor,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                            child: showNumber(
                                'Level',
                                Text(
                                  '${todoItem.level + (todoItem.done ? 1 : 0)}',
                                  textAlign: TextAlign.center,
                                  style: kNormalTextStyle,
                                ))),
                        VerticalDivider(
                          width: 60,
                          color: kEmphasisMainColor,
                        ),
                        Expanded(
                            child: showNumber(
                                'Row',
                                Text(
                                  '${todoItem.setRow()}',
                                  textAlign: TextAlign.center,
                                  style: kNormalTextStyle,
                                ))),
                        VerticalDivider(
                          width: 60,
                          color: kEmphasisMainColor,
                        ),
                        Expanded(
                          child: showNumber(
                              'Score',
                              Text(
                                '${(todoItem.strength * 100).toInt()}%',
                                textAlign: TextAlign.center,
                                style: kNormalTextStyle,
                              )),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget showNumber(String text, Widget num) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$text',
          textAlign: TextAlign.center,
          style: kEmphasisTextStyle,
        ),
        SizedBox(height: 5),
        num,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
