import 'package:check_mate/resources/todo_firestore_provider.dart';
import 'package:check_mate/widgets/flutter_login/flutter_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Status {
  Uninitialized,
  Authenticated,
  Unauthenticated,
}

enum UidExists {
  Exists,
  DoesNotExist,
}

class UserRepository with ChangeNotifier {
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  UidExists _uidExists = UidExists.Exists;
  TodoFirestoreProvider todoFirestoreProvider;

  UserRepository.instance() : _auth = FirebaseAuth.instance {
    _auth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  setUidExists() {
    _uidExists = UidExists.Exists;
    notifyListeners();
  }

  Future<bool> checkUidExist() async {
    List<dynamic> userUids = await todoFirestoreProvider.getUsersUidData();
    return userUids.contains(_user.uid) ? true : false;
  }

  Future checkNickname(String nickname) async {
    List<String> userNicknames =
        await todoFirestoreProvider.getUsersNicknameData();
    return userNicknames.contains(nickname) ? true : false;
  }

  Stream<QuerySnapshot> getNicknameSnapshot() {
    return todoFirestoreProvider.getUsersNicknameSnapshot();
  }

  Status get status => _status;
  FirebaseUser get user => _user;
  UidExists get uidExists => _uidExists;
  bool get loggedIn => _status == Status.Authenticated;

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
      todoFirestoreProvider = TodoFirestoreProvider(uid: _user.uid);
      todoFirestoreProvider.init();
      // check if uid exists.
      if (!(await checkUidExist())) {
        _uidExists = UidExists.DoesNotExist;
      }
      // only change to status authenticated when first app launch.
      // if unauthenticated => authenticated. that prevents login screen submit.
      if (_status == Status.Uninitialized) {
        _status = Status.Authenticated;
        notifyListeners();
      }
    }
  }
}
