import 'package:check_mate/constants.dart';
import 'package:check_mate/screens/add_todo_item_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TodoAddButton extends StatelessWidget {
  final double size;
  TodoAddButton({@required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: FittedBox(
        child: FloatingActionButton(
          child: Icon(FontAwesomeIcons.plus),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTodoItemScreen()));
          },
          backgroundColor: kMainColor,
        ),
      ),
    );
  }
}
