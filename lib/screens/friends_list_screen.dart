import 'package:check_mate/models/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, UserRepository user, _) {
        if (user.status == Status.Unauthenticated) {
          return Container(
            child: Text('로그인 해주세요.'),
          );
        } else {
          return StreamBuilder<QuerySnapshot>(
              stream: user.getNicknameSnapshot(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('Loading'),
                  );
                }
                List usersDocuments = snapshot.data.documents;
                List usersNickname =
                    usersDocuments.map((doc) => doc['nickname']).toList();
                usersNickname.sort();
                // todo make a user model
                return ListView.builder(
                  itemCount: usersDocuments.length,
                  itemBuilder: (context, idx) {
                    return ListTile(title: Text(usersNickname[idx]));
                  },
                );
              });
        }
      },
    );
  }
}
