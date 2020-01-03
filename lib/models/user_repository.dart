import 'package:check_mate/constants.dart';
import 'package:check_mate/models/cache.dart';
import 'package:check_mate/models/todo_item.dart';
import 'package:check_mate/models/todo_list.dart';
import 'package:check_mate/models/user_model.dart';
import 'package:check_mate/resources/todo_firestore_provider.dart';
import 'package:check_mate/widgets/flutter_login/flutter_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Unauthenticated,
}

enum NicknameExists {
  Exists,
  DoesNotExist,
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  NicknameExists _nicknameExists = NicknameExists.Exists;
  TodoFirestoreProvider todoFirestoreProvider;
  List<String> nicknames;
  UserModel userModel;
  String userNickname;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
    watchTodoBoxChange();
  }

  watchTodoBoxChange() {
    Box cacheBox = Hive.box(Boxes.cacheBox);
    Box todoItemBox = Hive.box(Boxes.todoItemBox);

    todoItemBox.watch().listen((event) async {
      if (event.deleted) {
        //firestore delete
//        print('${event.key} is now deleted');
//        print(todoFirestoreProvider);
//        print("deleting data");
        if (todoFirestoreProvider != null)
          todoFirestoreProvider.deleteUserTodoList(
              uid: _user.uid, key: event.key);
        else
          cacheBox.put(event.key, Cache(deleted: true, updated: false));
      } else {
//        print('${event.key} is now assigned to ${event.value}');
        TodoItem todoItem = event.value;
        if (todoFirestoreProvider != null) {
          print("sending data");
          todoFirestoreProvider.addUserTodoList(
            uid: _user.uid,
            key: todoItem.key,
            userTodoItem: todoItem.toMapForFirestore(),
          );
        } else
          cacheBox.put(event.key, Cache(deleted: false, updated: true));
      }
    });
  }

  reflectCache() {
    Box cacheBox = Hive.box(Boxes.cacheBox);
    Box todoItemBox = Hive.box(Boxes.todoItemBox);

    if (cacheBox.isNotEmpty) {
      cacheBox.values.forEach((cache) {
        Cache cacheItem = cache;
        int key = cacheItem.key;
        if (cacheItem.updated == true) if (todoItemBox.get(key) != null)
          todoFirestoreProvider.addUserTodoList(
            uid: _user.uid,
            key: key,
            userTodoItem: todoItemBox.get(key).toMapForFirestore(),
          );
        else
          todoFirestoreProvider.deleteUserTodoList(uid: _user.uid, key: key);
      });
    }
  }

  synchronizeTodo() async {
    QuerySnapshot todoQuerySnapshot =
        await todoFirestoreProvider.getUserTodoListCollection().getDocuments();
    List<DocumentSnapshot> todoDocuments = todoQuerySnapshot.documents;
    Box todoItemBox = Hive.box(Boxes.todoItemBox);
    List<TodoItem> todoItemListFromBox =
        todoItemBox.values.map((item) => item as TodoItem).toList();

    List<int> boxKeys =
        todoItemListFromBox.map((item) => item.key as int).toList();

    // get todoItems from Firestore that are not in the box
    todoDocuments
        .where((doc) => !boxKeys.contains(int.parse(doc.documentID)))
        .forEach((doc) {
      TodoItem todoItem = TodoItem(
          title: doc['title'],
          done: doc['done'],
          colorIndex: doc['colorIndex'],
          idx: todoItemBox.length);
      todoItemBox.put(int.parse(doc.documentID), todoItem);
      TodoList.itemList.add(todoItem);
    });
  }

  setNicknameExists() {
    _nicknameExists = NicknameExists.Exists;
    notifyListeners();
  }

  Future<void> getMyUserData() async {
    userModel = await todoFirestoreProvider.getUserData(uid: _user.uid);
    userModel?.saveBox();
    userNickname = userModel != null ? userModel.nickname : null;
  }

  Future<bool> checkUniqueNickname(String nickname) async {
    List<dynamic> userNicknames =
        await todoFirestoreProvider.getUsersNicknameData();
    return userNicknames.contains(nickname) ? false : true;
  }

  Stream<QuerySnapshot> getUsersSnapshot() {
    return todoFirestoreProvider.getUsersSnapshot();
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  NicknameExists get uidExists => _nicknameExists;
  bool get loggedIn => _status == Status.Authenticated;
  String get uid => _user?.uid;

  setStateAuthenticated() {
    _status = Status.Authenticated;
    notifyListeners();
  }

  Future<String> signUp(BuildContext context, LoginData data) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: data.name, password: data.password);
      return null;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.message;
    }
  }

  Future<String> signIn(BuildContext context, LoginData data) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: data.name, password: data.password);
      return null;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return e.message;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    _user = await _auth.currentUser();
    todoFirestoreProvider = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      notifyListeners();
    } else {
      // this is executed when logged in.
      _user = firebaseUser;
      // initialize firestore provider
      todoFirestoreProvider = TodoFirestoreProvider(myUid: _user.uid);
      todoFirestoreProvider.init();

      // reflect change to firebase if cache exists
      reflectCache();

      // initialize userModel
      // check if uid exists.
      await getMyUserData();
      print(userNickname);
      if (userNickname == null) {
        _nicknameExists = NicknameExists.DoesNotExist;
        notifyListeners();
      }

      synchronizeTodo();

      // only change to status authenticated when first app launch.
      // if unauthenticated => authenticated. that prevents login screen submit.
      if (_status == Status.Uninitialized) {
        _status = Status.Authenticated;
        notifyListeners();
      }
    }
  }
}
