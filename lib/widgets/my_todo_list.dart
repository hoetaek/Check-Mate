import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/widgets/calendar_view.dart';
import 'package:check_mate/widgets/dots_indicator.dart';
import 'package:check_mate/widgets/reorderable_slidable_list_view.dart';
import 'package:check_mate/widgets/todo_checkbox_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class MyTodoList extends StatefulWidget {
  @override
  _MyTodoListState createState() => _MyTodoListState();
}

class _MyTodoListState extends State<MyTodoList> {
  final controller = PageController();
  double _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView(
          onPageChanged: (page) {
            setState(() {
              _currentPage = page.toDouble();
            });
          },
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            TodoListView(),
            CalendarView(),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width: constraints.maxWidth,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: DotIndicator(
                  dotsCount: 2,
                  pageIndex: _currentPage,
                  activeColor: kEmphasisMainColor,
                  inactiveColor: kMainColor,
                ),
              ),
            );
          }),
        ),
      ],
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
          FontAwesomeIcons.sort,
          color: kMainColor,
        ),
        children: TodoList.itemList.map((TodoItem todoItem) {
          return TodoCheckboxTile(
            idx: TodoList.itemList.indexOf(todoItem),
          );
        }).toList(),
        onReorder: (oldIdx, newIdx) {
          todoList.reorder(oldIdx, newIdx);
        },
      );
    });
  }
}
