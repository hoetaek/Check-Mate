import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_model.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/friend_todolist_screen.dart';
import 'package:check_mate/widgets/friend_widget/friend_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class FriendsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, UserRepository user, _) {
        if (user.status == Status.Unauthenticated) {
          return Center(
            child: Text('로그인 해주세요.'),
          );
        } else {
          return StreamBuilder<QuerySnapshot>(
              stream: user.getUsersSnapshot(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('Loading'),
                  );
                }
                List usersDocuments = snapshot.data.documents;
                List<UserModel> userModelList = usersDocuments
                    .where((doc) => doc['uid'] != user.uid)
                    .map((doc) {
                  return UserModel(
                    uid: doc['uid'],
                    nickname: doc['nickname'],
                    profileURL: doc['profileURL'],
                    level: doc['level'],
                  );
                }).toList();
                // todo sort compare
//                userModelList.sort();
                return ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userModelList.length,
                  itemBuilder: (context, idx) {
                    UserModel userModel = userModelList[idx];
                    return FriendListTile(
                      userImage: Container(
                          height: 50,
                          child: userModel.profileURL != null
                              ? CachedNetworkImage(
                                  imageUrl: userModel.profileURL,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  imageBuilder: (context, imageProvider) =>
                                      FittedBox(
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundImage: imageProvider,
                                    ),
                                  ),
//                                      CircleAvatar(
//                                          radius: 20,
//                                          backgroundImage: imageProvider),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              : CircleAvatar(
                                  radius: 20,
                                  child: Icon(
                                    FontAwesomeIcons.userCircle,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  backgroundColor: Colors.transparent,
                                )),
                      title: Text(userModel.nickname,
                          style: GoogleTextStyle.tileTitleTextStyle),
                      subtitle: Text(
                        'Lv ${userModel.level}',
                        style: kTileSubtitle.copyWith(
                            fontWeight: FontWeight.normal),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: kEmphasisMainColor,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FriendTodoListScreen(
                                        userModel: userModel,
                                      )));
                        },
                      ),
                    );
                  },
                );
              });
        }
      },
    );
  }
}
