import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/widgets/app_bar/check_mate_logo_app_bar.dart';
import 'package:check_mate/widgets/color_picker.dart';
import 'package:check_mate/widgets/simple_button.dart';
import 'package:check_mate/widgets/simple_card.dart';
import 'package:check_mate/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddTodoItemScreen extends StatefulWidget {
  @override
  _AddTodoItemScreenState createState() => _AddTodoItemScreenState();
}

class _AddTodoItemScreenState extends State<AddTodoItemScreen> {
  final TextEditingController textController = TextEditingController();

  bool isShareOn = true;
  int colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CheckMateLogoAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              FractionallySizedBox(
                widthFactor: 1,
                child: Text(
                  '목표 추가하기',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display1,
                ),
              ),
              SizedBox(height: 30.0),
              SimpleTextField(
                labelText: '목표',
                color: Color.fromRGBO(234, 213, 242, 0.4),
                suffixIcon: Icon(FontAwesomeIcons.plus),
                controller: textController,
              ),
              SizedBox(height: 12.0),
              ColorPicker(
                index: colorIndex,
                onChange: (value) {
                  setState(() {
                    colorIndex = value;
                  });
                },
              ),
              SizedBox(height: 12.0),
              SwitchCard(
                isShareOn: isShareOn,
                onChange: (value) {
                  setState(() {
                    isShareOn = value;
                  });
                },
              ),
              SizedBox(height: 12.0),
              Center(
                child: SimpleButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () {
                    if (textController.text != '') {
                      DateTime now = DateTime.now();
                      TodoItem todoItem = TodoItem(
                        title: textController.text,
                        done: false,
                        idx: TodoList.itemList.length,
                        colorIndex: 3,
                        created: DateTime(now.year, now.month, now.day),
                        timestamp: DateTime.now(),
                        share: isShareOn,
                      );
                      Provider.of<TodoList>(context).addItem(todoItem);
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SwitchCard extends StatelessWidget {
  final Function onChange;
  final bool isShareOn;
  SwitchCard({@required this.isShareOn, @required this.onChange});

  @override
  Widget build(BuildContext context) {
    return SimpleCard(
      cardPadding: EdgeInsets.symmetric(horizontal: 9),
      color: Color.fromRGBO(234, 213, 242, 0.4),
      children: <Widget>[
        SwitchListTile(
          title: Text('공개'),
          value: isShareOn,
          onChanged: onChange,
          secondary: Icon(Icons.share),
        ),
      ],
    );
  }
}
