import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_model.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/widgets/app_bar/profile_appbar.dart';
import 'package:check_mate/widgets/friend_widget/friend_todo_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendTodoListScreen extends StatelessWidget {
  final UserModel userModel;
  FriendTodoListScreen({this.userModel});
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, UserRepository user, _) {
      return StreamBuilder<QuerySnapshot>(
          stream: user.todoFirestoreProvider
              .getUserTodoSnapshot(uid: userModel.uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Scaffold(
                appBar: ProfileAppBar(
                  userModel: UserModel(),
                ),
                body: Center(
                  child: Text('Loading'),
                ),
              );
            }
            List userTodoDocuments = snapshot.data.documents;
            userModel.getTodolistNumbers(userTodoDocuments);
            return Scaffold(
              appBar: ProfileAppBar(
                userModel: userModel,
              ),
              body: ListView.builder(
                itemCount: userTodoDocuments.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot todoItem = userTodoDocuments[index];
                  return FriendTodoTile(
                    checked: todoItem['done'],
                    title: Text(
                      "${todoItem['title']}",
                      style: GoogleTextStyle.tileTitleTextStyle,
                    ),
                    subtitle: Text(
                      "Lv${todoItem['level'] + (todoItem['done'] ? 1 : 0)}",
                      style: kTileSubtitle.copyWith(
                          color: kColors[todoItem['colorIndex']]),
                    ),
                  );
                },
              ),
            );
          });
    });
  }
}
