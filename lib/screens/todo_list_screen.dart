import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_model.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/user_info_screen.dart';
import 'package:check_mate/services/local_notification_helper.dart';
import 'package:check_mate/widgets/app_bar/profile_appbar.dart';
import 'package:check_mate/widgets/friend_widget/others_page_view.dart';
import 'package:check_mate/widgets/my_todo_list.dart';
import 'package:check_mate/widgets/sign_icon_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  final FirebaseMessaging _fcm = FirebaseMessaging();

  List<Widget> _children = [
    MyTodoList(),
    OthersPageView(),
  ];
  final notifications = FlutterLocalNotificationsPlugin();

  Future onSelectNotification(String payload) async => await Navigator.push(
      context, MaterialPageRoute(builder: (context) => TodoListScreen()));

  @override
  void initState() {
    super.initState();
    print("configure fcm");
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showOngoingNotification(notifications,
            title: message['notification']['title'],
            body: message['notification']['body'],
            id: int.parse(message['data']['id']));
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        showOngoingNotification(notifications,
            title: message['notification']['title'],
            body: message['notification']['body'],
            id: int.parse(message['data']['id']));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        showOngoingNotification(notifications,
            title: message['notification']['title'],
            body: message['notification']['body'],
            id: int.parse(message['data']['id']));
      },
    );

    if (Platform.isIOS)
      _fcm.requestNotificationPermissions(IosNotificationSettings());

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    final initializationSettingsAndroid =
        AndroidInitializationSettings('check_logo');
    final initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(
            initializationSettingsAndroid, initializationSettingsIOS),
        onSelectNotification: onSelectNotification);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, UserRepository user, _) {
        switch (user.uidExists) {
          case NicknameExists.Exists:
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
            break;
          case NicknameExists.DoesNotExist:
            return UserInfoScreen();
            break;
          default:
            return Container();
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
                        Provider.of<UserRepository>(context).loggedIn
                            ? FlatButton.icon(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserInfoScreen(
                                              userModel: UserModel.fromBox(),
                                              onSubmit: () =>
                                                  Navigator.pop(context),
                                            ))),
                                icon: Icon(Icons.settings),
                                label: Text('Edit Profile'))
                            : Container(),
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
