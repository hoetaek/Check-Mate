import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/widgets/todo_checkbox_leading_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoCheckboxTile extends StatelessWidget {
  final dynamic idx;
  final Key tileKey = UniqueKey();

  TodoCheckboxTile({this.idx});
  @override
  Widget build(BuildContext context) {
    TodoItem todoItem = Provider.of<TodoList>(context).getItem(idx);
    return CheckboxLeadingTile(
      idx: idx,
      key: tileKey,
      title: Text(
        todoItem.title,
        style: GoogleTextStyle.tileTitleTextStyle.copyWith(
            decoration: todoItem.done ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(
        'Lv.${todoItem.level + (todoItem.done ? 1 : 0)}',
        style: kTileSubtitle.copyWith(color: kColors[todoItem.colorIndex]),
      ),
      value: todoItem.done, //todoList.getDone(idx),
      onChanged: (value) {
        Provider.of<TodoList>(context).toggleDone(idx);
      },
      activeColor: kMainColor,
    );
  }
}
