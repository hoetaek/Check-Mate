import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/screens/add_todo_item_screen.dart';
import 'package:check_mate/widgets/app_bar/check_mate_logo_app_bar.dart';
import 'package:check_mate/widgets/color_picker.dart';
import 'package:check_mate/widgets/simple_button.dart';
import 'package:check_mate/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditTodoItemScreen extends StatefulWidget {
  final int idx;
  EditTodoItemScreen({@required this.idx});

  @override
  _EditTodoItemScreenState createState() => _EditTodoItemScreenState();
}

class _EditTodoItemScreenState extends State<EditTodoItemScreen> {
  final TextEditingController textController = TextEditingController();

  int colorIndex;
  bool isShareOn;

  @override
  void initState() {
    colorIndex = TodoList.itemList[widget.idx].colorIndex;
    isShareOn = TodoList.itemList[widget.idx].share;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CheckMateLogoAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  '목표 수정하기',
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.display1,
                ),
                SizedBox(height: 30.0),
                SimpleTextField(
                  labelText:
                      Provider.of<TodoList>(context).getTitle(widget.idx),
                  color: Color.fromRGBO(234, 213, 242, 0.4),
                  suffixIcon: Icon(FontAwesomeIcons.brush),
                  controller: textController,
                ),
                SizedBox(height: 12.0),
                ColorPicker(
                  index: colorIndex,
                  onChange: (id) {
                    setState(() {
                      colorIndex = id;
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
                    onPressed: () {
                      if (textController.text != '' ||
                          Provider.of<TodoList>(context)
                                  .getColorIndex(widget.idx) !=
                              colorIndex ||
                          TodoList.itemList[widget.idx].share != isShareOn) {
                        Provider.of<TodoList>(context).updateItem(
                            widget.idx,
                            textController.text == ''
                                ? Provider.of<TodoList>(context)
                                    .getTitle(widget.idx)
                                : textController.text,
                            colorIndex,
                            isShareOn);
                      }
                      Navigator.pop(context);
                    },
                    color: kEmphasisMainColor,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
