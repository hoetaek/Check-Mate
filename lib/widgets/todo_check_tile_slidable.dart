import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/screens/edit_todo_item_screen.dart';
import 'package:check_mate/screens/todo_item_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CheckTileSlidable extends StatelessWidget {
  final int idx;
  final Key key;
  final Widget child;
  CheckTileSlidable({this.idx, this.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: key,
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: child,
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.indigo,
          icon: FontAwesomeIcons.brush,
          onTap: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return EditTodoItemScreen(idx: idx);
          })),
        )
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'More',
          color: Colors.black45,
          icon: Icons.more_horiz,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TodoItemDetailPage(idx: idx))),
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            Provider.of<TodoList>(context).removeItem(idx);
          },
        ),
      ],
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary)
            Provider.of<TodoList>(context).removeItem(idx);
          else
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return EditTodoItemScreen(idx: idx);
            }));
        },
      ),
    );
  }
}
