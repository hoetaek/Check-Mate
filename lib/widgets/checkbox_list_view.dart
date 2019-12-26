import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/widgets/reorderable_slidable_list_view.dart';
import 'package:check_mate/widgets/todo_checkbox_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MyTodoList extends StatelessWidget {
  final controller = PageController();
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: controller,
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        TodoListView(),
        Calendar(),
      ],
    );
  }
}

class Calendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('달력에 모든 항목들의 완료 여부 표시'),
      ),
    );
  }
}

class TodoListView extends StatelessWidget {
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
        children: todoList.itemList.map((TodoItem todoItem) {
          return TodoCheckboxTile(
            idx: todoList.itemList.indexOf(todoItem),
          );
        }).toList(),
        onReorder: (oldIdx, newIdx) {
          todoList.reorder(oldIdx, newIdx);
        },
      );
    });
  }
}
