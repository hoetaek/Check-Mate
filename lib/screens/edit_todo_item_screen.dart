import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/widgets/check_mate_logo_app_bar.dart';
import 'package:check_mate/widgets/simple_button.dart';
import 'package:check_mate/widgets/simple_text_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class EditTodoItemScreen extends StatelessWidget {
  final int idx;
  EditTodoItemScreen({@required this.idx});
  final TextEditingController textController = TextEditingController();

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
                height: 30.0,
              ),
              Text(
                '목표 수정하기',
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.display1,
              ),
              SizedBox(height: 30.0),
              SimpleTextField(
                labelText: Provider.of<TodoList>(context).getTitle(idx),
                color: Color.fromRGBO(234, 213, 242, 0.4),
                suffixIcon: Icon(FontAwesomeIcons.brush),
                controller: textController,
              ),
              SizedBox(height: 12.0),
              Center(
                child: SimpleButton(
                  onPressed: () {
                    if (textController.text != '') {
                      Provider.of<TodoList>(context)
                          .updateItem(idx, textController.text);
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
    );
  }
}
