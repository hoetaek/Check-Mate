import 'dart:io';

import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TodoItemAdapter(), 0);
  runApp(CheckMate());
}

class CheckMate extends StatefulWidget {
  @override
  _CheckMateState createState() => _CheckMateState();
}

class _CheckMateState extends State<CheckMate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => TodoList()),
          ChangeNotifierProvider(create: (_) => UserRepository.instance()),
        ],
        child: MaterialApp(
            title: 'Check Mate',
            theme: ThemeData(
              cardTheme: CardTheme(
                elevation: 12.0,
                margin: EdgeInsets.all(4.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
              primaryColor: kMainColor,
              textTheme: GoogleFonts.nanumGothicCodingTextTheme(
                Theme.of(context).textTheme,
              ),
            ),
            home: TodoListScreen()));
  }

  @override
  void dispose() {
    Hive.box(Boxes.todoItemBox).compact();
    Hive.close();
    super.dispose();
  }
}
