import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_model.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/user_info_screen.dart';
import 'package:check_mate/widgets/app_bar/profile_appbar.dart';
import 'package:check_mate/widgets/friend_widget/friends_list_view.dart';
import 'package:check_mate/widgets/my_todo_list.dart';
import 'package:check_mate/widgets/sign_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  NicknameExists uidExists;
  UserModel userModel = UserModel.fromBox();
  List<Widget> _children = [
    MyTodoList(),
    FriendsListView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, UserRepository user, _) {
        if (user.uidExists == NicknameExists.Exists) {
          return WatchBoxBuilder(
              box: Hive.box(Boxes.userBox),
              builder: (context, userBox) {
                return WatchBoxBuilder(
                    box: Hive.box(Boxes.todoItemBox),
                    builder: (context, todoBox) {
                      return Scaffold(
                        key: _scaffoldKey,
                        appBar: ProfileAppBar(
                            userModel:
                                userModel.getTodolistNumbersFromBox(todoBox),
                            scaffoldKey: _scaffoldKey),
                        endDrawer: EndDrawer(userModel: userModel),
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
                    });
              });
        } else {
          return UserInfoScreen();
        }
      },
    );
  }
}

class EndDrawer extends StatelessWidget {
  const EndDrawer({
    Key key,
    @required this.userModel,
  }) : super(key: key);

  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Important: Remove any padding from the ListView.
//                      padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: Scaffold.of(context).appBarMaxHeight,
            color: kMainColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: FittedBox(
                      child: userModel.profileURL != null
                          ? CachedNetworkImage(
                              imageUrl: userModel.profileURL,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                      radius: 45,
                                      backgroundImage: imageProvider),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : CircleAvatar(
                              radius: 40,
                              child: Icon(
                                FontAwesomeIcons.userCircle,
                                size: 70,
                                color: Colors.black,
                              ),
                              backgroundColor: Colors.transparent,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '@${userModel.nickname}',
                          style: GoogleTextStyle.tileTitleTextStyle
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Expanded(child: Container()),
                        FlatButton.icon(
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserInfoScreen(
                                          userModel: UserModel.fromBox(),
                                        ))),
                            icon: Icon(Icons.settings),
                            label: Text('Edit Profile'))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(),
          ),
          SafeArea(
              child: Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: SignIconButton(),
          )),
        ],
      ),
    );
  }
}
