import 'package:check_mate/models/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class CheckTileSlidable extends StatelessWidget {
  final int idx;
  final Key key;
  final Widget child;
  CheckTileSlidable({this.idx, this.key, this.child});

  _showSnackBar(text) {
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: child,
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'More',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => _showSnackBar('More'),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => Provider.of<TodoList>(context).removeItem(idx),
        ),
      ],
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          Provider.of<TodoList>(context).removeItem(idx);
        },
      ),
    );
  }
}
