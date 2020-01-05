import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_model.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/screens/friend_todolist_screen.dart';
import 'package:check_mate/widgets/dots_indicator.dart';
import 'package:check_mate/widgets/friend_widget/friend_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

final _firestore = Firestore.instance;

class OthersPageView extends StatefulWidget {
  @override
  _OthersPageViewState createState() => _OthersPageViewState();
}

class _OthersPageViewState extends State<OthersPageView> {
  final controller = PageController();
  double _currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        PageView(
          onPageChanged: (page) {
            setState(() {
              _currentPage = page.toDouble();
            });
          },
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            FriendsListView(),
            UsersListview(),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width: constraints.maxWidth,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Center(
                child: DotIndicator(
                  dotsCount: 2,
                  pageIndex: _currentPage,
                  activeColor: kEmphasisMainColor,
                  inactiveColor: kMainColor,
                ),
              ),
            );
          }),
        )
      ],
    );
  }
}

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
              stream: _firestore
                  .collection('Users')
                  .document(user.uid)
                  .collection('Following')
                  .snapshots(),
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
                    profilePath: doc['profilePath'],
                    profileURL: doc['profileURL'],
                    level: doc['level'],
                  );
                }).toList();
//                userModelList.sort();
                return ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: userModelList.length,
                  itemBuilder: (context, idx) {
                    UserModel userModel = userModelList[idx];
                    return Slidable(
                      key: UniqueKey(),
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                            caption: '언팔로우',
                            color: kEmphasisMainColor,
                            icon: Icons.clear,
                            onTap: () {
                              _firestore
                                  .collection('Users')
                                  .document(user.uid)
                                  .collection('Following')
                                  .document(userModel.uid)
                                  .delete();
                              _firestore
                                  .collection('Users')
                                  .document(user.uid)
                                  .collection("UnFollowing")
                                  .document(userModel.uid)
                                  .setData(userModel.toMap());
                            }),
                      ],
                      dismissal: SlidableDismissal(
                          child: SlidableDrawerDismissal(),
                          onDismissed: (actionType) {
                            _firestore
                                .collection('Users')
                                .document(user.uid)
                                .collection('Following')
                                .document(userModel.uid)
                                .delete();
                            _firestore
                                .collection('Users')
                                .document(user.uid)
                                .collection("UnFollowing")
                                .document(userModel.uid)
                                .setData(userModel.toMap());
                          }),
                      child: FriendListTile(
                        userImage: Container(
                            height: 50,
                            child: userModel.profileURL != null
                                ? CachedNetworkImage(
                                    imageUrl: userModel.profileURL,
                                    placeholder: (context, url) => FittedBox(
                                        child: CircularProgressIndicator()),
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

class UsersListview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, UserRepository user, _) {
        if (user.status == Status.Unauthenticated) {
          return Center(
            child: Text('로그인 해주세요.'),
          );
        } else {
//          final Stream<List<DocumentSnapshot>> list = // get list from some source, like BLOC
          return AnimatedStreamList<UserModel>(
            streamList: _firestore
                .collection("Users")
                .document(user.uid)
                .collection("UnFollowing")
                .snapshots()
                .map((snapshot) => snapshot.documents
                    .map((doc) => UserModel(
                          uid: doc['uid'],
                          nickname: doc['nickname'],
                          profilePath: doc['profilePath'],
                          profileURL: doc['profileURL'],
                          level: doc['level'],
                        ))
                    .toList()),
            itemBuilder: (UserModel userModel, int index, BuildContext context,
                Animation<double> animation) {
              return _createTile(user, userModel, animation);
            },
            itemRemovedBuilder: (UserModel userModel, int index,
                    BuildContext context, Animation<double> animation) =>
                _createRemovedTile(user, userModel, animation),
          );
        }

//          return StreamBuilder<QuerySnapshot>(
//              stream: _firestore
//                  .collection("Users")
//                  .document(user.uid)
//                  .collection("UnFollowing")
//                  .snapshots(),
//              builder: (context, snapshot) {
//                if (!snapshot.hasData) {
//                  return Center(
//                    child: Text('Loading'),
//                  );
//                }
//                List usersDocuments = snapshot.data.documents;
//                List<UserModel> userModelList = usersDocuments
//                    .where((doc) => doc['uid'] != user.uid)
//                    .map((doc) {
//                  return UserModel(
//                    uid: doc['uid'],
//                    nickname: doc['nickname'],
//                    profilePath: doc['profilePath'],
//                    profileURL: doc['profileURL'],
//                    level: doc['level'],
//                  );
//                }).toList();
////                userModelList.sort();
//                return ListView.builder(
//                  physics: ScrollPhysics(),
//                  shrinkWrap: true,
//                  itemCount: userModelList.length,
//                  itemBuilder: (context, idx) {
//                    UserModel userModel = userModelList[idx];
//                    return FriendListTile(
//                      userImage: Container(
//                          height: 50,
//                          child: userModel.profileURL != null
//                              ? CachedNetworkImage(
//                                  imageUrl: userModel.profileURL,
//                                  placeholder: (context, url) => FittedBox(
//                                      child: CircularProgressIndicator()),
//                                  imageBuilder: (context, imageProvider) =>
//                                      FittedBox(
//                                    child: CircleAvatar(
//                                      radius: 20,
//                                      backgroundImage: imageProvider,
//                                    ),
//                                  ),
////                                      CircleAvatar(
////                                          radius: 20,
////                                          backgroundImage: imageProvider),
//                                  errorWidget: (context, url, error) =>
//                                      Icon(Icons.error),
//                                )
//                              : CircleAvatar(
//                                  radius: 20,
//                                  child: Icon(
//                                    FontAwesomeIcons.userCircle,
//                                    size: 40,
//                                    color: Colors.black,
//                                  ),
//                                  backgroundColor: Colors.transparent,
//                                )),
//                      title: Text(userModel.nickname,
//                          style: GoogleTextStyle.tileTitleTextStyle),
//                      subtitle: Text(
//                        'Lv ${userModel.level}',
//                        style: kTileSubtitle.copyWith(
//                            fontWeight: FontWeight.normal),
//                      ),
//                      trailing: Padding(
//                        padding: const EdgeInsets.only(right: 17.0),
//                        child: GestureDetector(
//                          child: Container(
//                            color: kMainColor,
//                            child: Padding(
//                              padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
//                              child: Text(
//                                '팔로우',
//                                style: kButtonTextStyle.copyWith(fontSize: 14),
//                              ),
//                            ),
//                          ),
//                          onTap: () {
//                            print(userModel.toMap());
//                            _firestore
//                                .collection('Users')
//                                .document(user.uid)
//                                .collection('UnFollowing')
//                                .document(userModel.uid)
//                                .delete();
//
//                            _firestore
//                                .collection('Users')
//                                .document(user.uid)
//                                .collection('Following')
//                                .document(userModel.uid)
//                                .setData(userModel.toMap());
//                          },
//                        ),
//                      ),
//                    );
//                  },
//                );
//              });
//        }
      },
    );
  }

  // create tile view as the user is going to see it, attach any onClick callbacks etc.
  Widget _createTile(
      UserRepository user, UserModel userModel, Animation<double> animation) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: FriendListTile(
        userImage: Container(
            height: 50,
            child: userModel.profileURL != null
                ? CachedNetworkImage(
                    imageUrl: userModel.profileURL,
                    placeholder: (context, url) =>
                        FittedBox(child: CircularProgressIndicator()),
                    imageBuilder: (context, imageProvider) => FittedBox(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: imageProvider,
                      ),
                    ),
//                                      CircleAvatar(
//                                          radius: 20,
//                                          backgroundImage: imageProvider),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
        title:
            Text(userModel.nickname, style: GoogleTextStyle.tileTitleTextStyle),
        subtitle: Text(
          'Lv ${userModel.level}',
          style: kTileSubtitle.copyWith(fontWeight: FontWeight.normal),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 17.0),
          child: GestureDetector(
            child: Container(
              color: kMainColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                child: Text(
                  '팔로우',
                  style: kButtonTextStyle.copyWith(fontSize: 14),
                ),
              ),
            ),
            onTap: () {
              _firestore
                  .collection('Users')
                  .document(user.uid)
                  .collection('UnFollowing')
                  .document(userModel.uid)
                  .delete();

              _firestore
                  .collection('Users')
                  .document(user.uid)
                  .collection('Following')
                  .document(userModel.uid)
                  .setData(userModel.toMap());
            },
          ),
        ),
      ),
    );
  }

// what is going to be shown as the tile is being removed, usually same as above but without any
// onClick callbacks as, most likely, you don't want the user to interact with a removed view
  Widget _createRemovedTile(
      UserRepository user, UserModel userModel, Animation<double> animation) {
    return SizeTransition(
      axis: Axis.vertical,
      sizeFactor: animation,
      child: FriendListTile(
        userImage: Container(
            height: 50,
            child: userModel.profileURL != null
                ? CachedNetworkImage(
                    imageUrl: userModel.profileURL,
                    placeholder: (context, url) =>
                        FittedBox(child: CircularProgressIndicator()),
                    imageBuilder: (context, imageProvider) => FittedBox(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: imageProvider,
                      ),
                    ),
//                                      CircleAvatar(
//                                          radius: 20,
//                                          backgroundImage: imageProvider),
                    errorWidget: (context, url, error) => Icon(Icons.error),
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
        title:
            Text(userModel.nickname, style: GoogleTextStyle.tileTitleTextStyle),
        subtitle: Text(
          'Lv ${userModel.level}',
          style: kTileSubtitle.copyWith(fontWeight: FontWeight.normal),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 17.0),
          child: GestureDetector(
            child: Container(
              color: kMainColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                child: Text(
                  '팔로우',
                  style: kButtonTextStyle.copyWith(fontSize: 14),
                ),
              ),
            ),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
