import 'dart:io';

import 'package:check_mate/constants.dart';
import 'package:check_mate/models/cache.dart';
import 'package:check_mate/models/record.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(TodoItemAdapter(), 0);
  Hive.registerAdapter(RecordAdapter(), 1);
  Hive.registerAdapter(CacheAdapter(), 2);
  runApp(CheckMate());
}

class CheckMate extends StatefulWidget {
  @override
  _CheckMateState createState() => _CheckMateState();
}

class _CheckMateState extends State<CheckMate> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoList()),
        ChangeNotifierProvider(create: (_) => UserRepository.instance()),
      ],
      child: MaterialApp(
        title: 'Check Mate',
        theme: ThemeData(
          primaryColor: kMainColor,
          textTheme: GoogleFonts.montserratTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }

  @override
  void dispose() {
    Hive.box(Boxes.todoItemBox).compact();
    Hive.box(Boxes.recordsBox).compact();
    Hive.close();
    super.dispose();
  }
}
