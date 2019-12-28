import 'dart:async';

import 'package:check_mate/constants.dart';
import 'package:check_mate/screens/todo_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<Timer> loadData() async {
    await Hive.openBox(Boxes.todoItemBox,
        compactionStrategy: (int total, int deleted) {
      return deleted > 20;
    });
    return Timer(Duration(milliseconds: 1600), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TodoListScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Image.asset('assets/check_logo.png'),
          ),
          SizedBox(
            height: 20,
          ),
          Text('Check Mate',
              style: GoogleFonts.nanumGothicCodingTextTheme()
                  .display2
                  .copyWith(color: kEmphasisMainColor, fontSize: 50)),
          Flexible(
            child: FractionallySizedBox(
              heightFactor: 0.3,
              child: Container(),
            ),
          ),
          CircularProgressIndicator(
            backgroundColor: kEmphasisMainColor,
            valueColor: AlwaysStoppedAnimation<Color>(kMainColor),
          ),
          SizedBox(
            height: 25,
          ),
          RichText(
            text: TextSpan(
              style: GoogleFonts.nanumGothicCodingTextTheme()
                  .display2
                  .copyWith(color: Colors.white, fontSize: 25),
              children: <TextSpan>[
                TextSpan(text: 'Make '),
                TextSpan(
                    text: 'Habit',
                    style: GoogleFonts.nanumGothicCodingTextTheme()
                        .display2
                        .copyWith(color: kEmphasisMainColor, fontSize: 25)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              style: GoogleFonts.nanumGothicCodingTextTheme()
                  .display2
                  .copyWith(color: Colors.white, fontSize: 25),
              children: <TextSpan>[
                TextSpan(text: 'Make '),
                TextSpan(
                    text: 'Life',
                    style: GoogleFonts.nanumGothicCodingTextTheme()
                        .display2
                        .copyWith(color: kEmphasisMainColor, fontSize: 25)),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
            text: TextSpan(
              style: GoogleFonts.nanumGothicCodingTextTheme()
                  .display2
                  .copyWith(color: Colors.white, fontSize: 25),
              children: <TextSpan>[
                TextSpan(text: 'With '),
                TextSpan(
                    text: 'Friends:)',
                    style: GoogleFonts.nanumGothicCodingTextTheme()
                        .display2
                        .copyWith(color: kEmphasisMainColor, fontSize: 25)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
