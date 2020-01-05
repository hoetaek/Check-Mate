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
    await Hive.openBox(Boxes.cacheBox,
        compactionStrategy: (int total, int deleted) {
      return deleted > 20;
    });
    await Hive.openBox(Boxes.todoItemBox,
        compactionStrategy: (int total, int deleted) {
      return deleted > 20;
    });
    return Timer(Duration(milliseconds: 1300), onDoneLoading);
  }

  onDoneLoading() async {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TodoListScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox(Boxes.userBox,
          compactionStrategy: (int total, int deleted) {
        return deleted > 20;
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError)
            return Text(snapshot.error.toString());
          else {
            Box userBox = Hive.box(Boxes.userBox);
            return Loading(
              userBox: userBox,
            );
          }
        }
        // Although opening a Box takes a very short time,
        // we still need to return something before the Future completes.
        else
          return Loading();
      },
    );
  }
}

class Loading extends StatelessWidget {
  final Box userBox;
  Loading({this.userBox});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kMainColor,
        body: LayoutBuilder(builder: (context, constraints) {
          userBox?.put('maxHeight', constraints.maxHeight);
          return Column(
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
                  heightFactor: 0.4,
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
          );
        }),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: kMainColor,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.clear,
                color: kMainColor,
              ),
              title: Text(
                'text',
                style: TextStyle(color: kMainColor),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.clear,
                color: kMainColor,
              ),
              title: Text(
                'text',
                style: TextStyle(color: kMainColor),
              ),
            ),
          ],
        ));
  }
}
