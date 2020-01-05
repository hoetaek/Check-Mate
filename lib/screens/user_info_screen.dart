import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_mate/constants.dart';
import 'package:check_mate/models/user_model.dart';
import 'package:check_mate/models/user_repository.dart';
import 'package:check_mate/resources/profile_firestorage_provider.dart';
import 'package:check_mate/widgets/simple_button.dart';
import 'package:check_mate/widgets/simple_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'package:provider/provider.dart';

class UserInfoScreen extends StatefulWidget {
  final UserModel userModel;
  final Function onSubmit;
  const UserInfoScreen({Key key, this.userModel, this.onSubmit})
      : super(key: key);
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormFieldState>();
  bool isUniqueNickname = false;
  final TextEditingController controller = TextEditingController();
  File _image;
  Widget buttonPressed;
  final String defaultPath = 'check_logo.png';
  final String defaultImage =
      "https://firebasestorage.googleapis.com/v0/b/check-mate-745fc.appspot.com/o/check_logo.png?alt=media&token=d3899036-f264-4027-98e9-c0960c092b39";

  void openCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
  }

  void openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 정보', style: Theme.of(context).textTheme.display1),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Consumer(builder: (context, UserRepository userRepo, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      _optionsDialogBox();
                    },
                    child: widget.userModel == null
                        // on Sign up
                        // if there is no image display nothing
                        // if there is image display the image
                        ? CircleAvatar(
                            backgroundImage: _image == null
                                ? null
                                : Image.file(_image).image,
                            radius: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _image == null
                                    ? Icon(
                                        Icons.camera,
                                        color: Colors.white,
                                        size: 15,
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 15,
                                ),
                                _image == null
                                    ? Text(
                                        'Profile Picture',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          )
                        :
                        // on edit profile
                        // if there is no image display the original image
                        // if there is image display the image
                        _image == null
                            ? CachedNetworkImage(
                                imageUrl: widget.userModel.profileURL,
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                        radius: 50,
                                        backgroundImage: imageProvider,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            _image == null
                                                ? Icon(
                                                    Icons.camera,
                                                    color: Colors.white,
                                                    size: 15,
                                                  )
                                                : Container(),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            _image == null
                                                ? Text(
                                                    'Profile Picture',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        )),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : CircleAvatar(
                                backgroundImage: _image == null
                                    ? null
                                    : Image.file(_image).image,
                                radius: 50,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    _image == null
                                        ? Icon(
                                            Icons.camera,
                                            color: Colors.white,
                                            size: 15,
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    _image == null
                                        ? Text(
                                            'Profile Picture',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                  ),
                  SizedBox(height: 12),
                  FractionallySizedBox(
//                  widthFactor: 0.7,
                    child: SimpleTextField(
                      formKey: _formKey,
                      validator: (String value) {
                        if (value.isEmpty) {
                          if (widget.onSubmit == null) return "닉네임을 입력하세요.";
                          if (_image == null) return "닉네임을 입력하세요.";
                        } else if (value.contains(" ")) {
                          return "빈칸을 제거해주세요.";
                        } else if (!isUniqueNickname) {
                          return "이미 존재하는 닉네임입니다.";
                        }
                        return null;
                      },
                      suffixIcon: Icon(FontAwesomeIcons.user),
                      labelText: widget.userModel?.nickname ?? "닉네임",
                      controller: controller,
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: buttonPressed ??
                        SimpleButton(
                          color: kMainColor,
                          title: Text(
                            '확인',
                            style: Theme.of(context).textTheme.button.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: () async {
                            isUniqueNickname = await userRepo
                                .checkUniqueNickname(controller.text);
                            if (!(_formKey.currentState.validate())) return;

                            setState(() {
                              buttonPressed =
                                  FittedBox(child: CircularProgressIndicator());
                            });
                            String downloadURL;
                            String profilePath;
                            if (widget.onSubmit != null) {
                              profilePath = widget.userModel.profilePath;
                              downloadURL = widget.userModel.profileURL;
                            }
                            if (_image != null) {
                              profilePath = basename(_image.path);
                              downloadURL =
                                  await ProfileFirestorageProvider.uploadFile(
                                      _image);
                            }

                            FirebaseUser user = userRepo.user;

                            UserModel userModel = UserModel(
                              uid: user.uid,
                              nickname: controller.text == ""
                                  ? widget.userModel.nickname
                                  : controller.text,
                              profilePath: profilePath == null
                                  ? defaultPath
                                  : profilePath,
                              profileURL: downloadURL == null
                                  ? defaultImage
                                  : downloadURL,
                              level: widget.userModel?.level ?? 1,
                            );
                            userRepo.todoFirestoreProvider
                                .addUsersData(userModel);
                            userModel.saveBox();
                            userRepo.userNickname = controller.text;
                            userRepo.setNicknameExists();
                            if (widget.onSubmit != null) widget.onSubmit();
                          },
                        ),
                  )
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('Take a picture'),
                    onTap: openCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text('Select from gallery'),
                    onTap: openGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
