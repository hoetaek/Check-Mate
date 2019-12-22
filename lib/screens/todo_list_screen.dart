import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/friends_list_screen.dart';
import 'package:check_mate/screens/signup_screen.dart';
import 'package:check_mate/widgets/check_mate_icon_app_bar.dart';
import 'package:check_mate/widgets/checkbox_list_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  int _currentIndex = 0;
  UidExists uidExists;
  List<Widget> _children = [
    CheckboxListView(),
    FriendsListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, UserRepository user, _) {
        if (user.uidExists == UidExists.Exists) {
          return Scaffold(
            appBar: CheckMateIconAppBar(),
            body: _children[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.solidUser),
                  title: Text('My List'),
                ),
                BottomNavigationBarItem(
                    icon: Icon(FontAwesomeIcons.userFriends),
                    title: Text('Friend List')),
              ],
            ),
          );
        } else {
          return SignupScreen();
        }
      },
    );
  }
}
