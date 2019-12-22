import 'package:check_mate/constants.dart';
import 'package:check_mate/models/item_model.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/widgets/reorderable_slidable_list_view.dart';
import 'package:check_mate/widgets/todo_checkbox_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class CheckboxListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoList>(builder: (context, todoList, child) {
      return ReorderableSlidableListView(
        handleSide: ReorderableListSimpleSide.Right,
        padding: EdgeInsets.only(right: 20.0),
        handleIcon: Icon(
          FontAwesomeIcons.bars,
          color: kMainColor,
        ),
        children: todoList.itemList
            .map((ItemModel todoItem) => TodoCheckboxTile(
                  idx: todoList.itemList.indexOf(todoItem),
                  key: UniqueKey(),
                ))
            .toList(),
        onReorder: (oldIdx, newIdx) {
          todoList.reorder(oldIdx, newIdx);
          print(todoList.itemList.map((x) => x.title).toList());
          print(todoList.itemList.map((x) => x.done).toList());
          print(todoList.itemList.map((x) => x.idx).toList());
        },
      );
    });
  }
}
