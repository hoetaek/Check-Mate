import 'package:check_mate/constants.dart';
import 'package:hive/hive.dart';

class UserModel {
  String uid;
  String nickname;
  String profilePath;
  String profileURL;
  int total;
  int done;
  int left;
  int level;

  UserModel(
      {this.uid, this.profilePath, this.nickname, this.profileURL, this.level});

  UserModel.parseMap(Map<String, dynamic> userData) {
    uid = userData["uid"];
    nickname = userData["nickname"];
    profileURL = userData["profileURL"];
  }

  UserModel.fromBox() {
    Box userBox = Hive.box(Boxes.userBox);
    uid = userBox.get("uid");
    nickname = userBox.get("nickname") ?? "닉네임";
    profilePath = userBox.get("profilePath");
    profileURL = userBox.get("profileURL");
    level = userBox.get("level");
    userBox.watch().listen((event) {
      uid = userBox.get("uid");
      nickname = userBox.get("nickname") ?? "닉네임";
      profileURL = userBox.get("profileURL");
      level = userBox.get("level");
    });
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "nickname": nickname,
      "profilePath": profilePath,
      "profileURL": profileURL,
      "level": level
    };
  }

  void getTodolistNumbers(List todolistDocuments) {
    total = todolistDocuments.length;
    done = todolistDocuments.where((doc) => doc.data["done"] == true).length;
    left = total - done;
  }

  UserModel getTodolistNumbersFromBox(Box box) {
    total = box.isNotEmpty ? box.length : 0;
    done = box.isNotEmpty
        ? box.values.where((item) => item.done == true).length
        : 0;
    left = box.isNotEmpty
        ? box.values.where((item) => item.done == false).length
        : 0;
    return this;
  }

  void saveBox() {
    Box userBox = Hive.box(Boxes.userBox);
    userBox.put('uid', uid);
    userBox.put('nickname', nickname);
    userBox.put('profilePath', profilePath);
    userBox.put('profileURL', profileURL);
    userBox.put('level', level);
  }
}
