import 'package:check_mate/constants.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() => runApp(CheckMate());

class CheckMate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => TodoList()),
          ChangeNotifierProvider(builder: (_) => UserRepository.instance()),
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
            home: TodoListScreen()
            //todo 차라리 처음부터 투두리스트 스크린 보여주고, 로그인 상태에 따라서 로그인/로그아웃 아이콘 표시
            //todo 로그인 버튼을 누르면 로그인스크린을 push, 로그아웃 누르면 로그아웃 다이얼로그 표시

            ));
  }
}
