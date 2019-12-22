import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/widgets/checkbox_leading_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TodoCheckboxTile extends StatelessWidget {
  final int idx;
  final Key key;

  TodoCheckboxTile({this.idx, this.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoList>(builder: (context, todoList, child) {
      return CheckboxLeadingTile(
        //todo colored water fills up as animation
        idx: idx,
        title: Text(
          todoList.getTitle(idx),
          style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.w500,
                  decoration:
                      todoList.getDone(idx) ? TextDecoration.lineThrough : null)
              .merge(GoogleFonts.notoSans()),
        ),
        subtitle: Text(
          'Lv.1',
          style: TextStyle(
              color: Colors.accents[1],
              fontWeight: FontWeight.bold,
              fontSize: 16.0),
        ),
        value: todoList.getDone(idx),
        onChanged: (value) {
          todoList.toggleDone(idx);
        },
        activeColor: kMainColor,
      );
    });
  }
}
