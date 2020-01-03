import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_model.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 140;
  final UserModel userModel;
  final GlobalKey<ScaffoldState> scaffoldKey;

  ProfileAppBar({@required this.userModel, this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            decoration: BoxDecoration(color: kMainColor, boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 3.0, spreadRadius: 0.3)
            ]),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            '@${userModel.nickname}',
                            style: GoogleTextStyle.tileTitleTextStyle.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        (userModel.uid ==
                                    Provider.of<UserRepository>(context).uid ||
                                Provider.of<UserRepository>(context).uid ==
                                    null)
                            ? Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.bars,
                                    color: kEmphasisMainColor,
                                  ),
                                  onPressed: () {
                                    scaffoldKey.currentState.openEndDrawer();
                                  },
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.doorOpen,
                                    color: kEmphasisMainColor,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    flex: 3,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: FittedBox(
                            child: userModel.profileURL != null
                                ? CachedNetworkImage(
                                    imageUrl: userModel.profileURL,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                            radius: 50,
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
                          child: Container(),
                        ),
                        showNumber('Total', userModel.total),
                        VerticalDivider(
                          width: 60,
                          color: kEmphasisMainColor,
                        ),
                        showNumber('Done', userModel.done),
                        VerticalDivider(
                          width: 60,
                          color: kEmphasisMainColor,
                        ),
                        showNumber('Left', userModel.left),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget showNumber(String text, int num) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$text',
          textAlign: TextAlign.center,
          style: kEmphasisTextStyle,
        ),
        SizedBox(height: 5),
        Text(
          '$num',
          textAlign: TextAlign.center,
          style: kNormalTextStyle,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
