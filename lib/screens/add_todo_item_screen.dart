import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/widgets/check_mate_logo_app_bar.dart';
import 'package:check_mate/widgets/color_picker.dart';
import 'package:check_mate/widgets/simple_button.dart';
import 'package:check_mate/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddTodoItemScreen extends StatelessWidget {
  final GlobalKey<ColorPickerState> colorKey = GlobalKey<ColorPickerState>();
  final TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CheckMateLogoAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text(
              '목표 추가하기',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.display1,
            ),
            SizedBox(height: 30.0),
            SimpleTextField(
              labelText: '목표',
              color: Color.fromRGBO(234, 213, 242, 0.4),
              suffixIcon: Icon(FontAwesomeIcons.plus),
              controller: textController,
            ),
            SizedBox(height: 12.0),
            ColorPicker(key: colorKey),
            SizedBox(height: 12.0),
            Center(
              child: SimpleButton(
                color: Colors.lightBlueAccent,
                onPressed: () {
                  if (textController.text != '') {
                    TodoItem todoItem = TodoItem(
                        title: textController.text,
                        done: false,
                        idx: Provider.of<TodoList>(context).itemList.length,
                        colorIndex: colorKey.currentState.colorIndex);
                    Provider.of<TodoList>(context).addItem(todoItem);
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
