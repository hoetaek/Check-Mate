import 'package:check_mate/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TodoFirestoreProvider {
  final String myUid;
  TodoFirestoreProvider({this.myUid});
  Collection usersCollection;

  init() {
    usersCollection = Collection(collectionName: "Users");
    usersCollection.init();
    Firestore.instance.settings(persistenceEnabled: true);
  }

  addUsersData(UserModel userModel) {
    Map<String, dynamic> userData = userModel.toMap();
    usersCollection.addDocument(documentData: userData);
  }

  Stream<QuerySnapshot> getUsersSnapshot() {
    return usersCollection.getCollection.snapshots();
  }

  Future<List<dynamic>> getUsersUidData() async {
    QuerySnapshot usersData = await getUsersDocuments;
    return usersData.documents.map((data) => data.data["uid"]).toList();
  }

  Future<List<dynamic>> getUsersNicknameData() async {
    QuerySnapshot usersData = await getUsersDocuments;
    return usersData.documents.map((data) => data.data["nickname"]).toList();
  }

  Future<QuerySnapshot> get getUsersDocuments async =>
      await usersCollection.getCollection.getDocuments();

  Future<UserModel> getUserData({String uid}) async {
    DocumentSnapshot usersData =
        await usersCollection.getCollection.document(uid).get();
    if (usersData.data != null)
      return UserModel.parseMap(usersData.data);
    else
      return null;
  }

  Future<String> getUserNickname({String uid}) async {
    UserModel userModel = await getUserData(uid: uid);
    if (userModel != null) {
      return userModel.nickname;
    } else
      return null;
  }

  addUserTodoList({uid, key, Map<String, dynamic> userTodoItem}) {
    CollectionReference userTodoListCollection =
        getUserTodoListCollection(uid: uid);
    userTodoListCollection.document(key.toString()).setData(userTodoItem);
  }

  deleteUserTodoList({uid, key}) {
    CollectionReference userTodoListCollection =
        getUserTodoListCollection(uid: uid);
    userTodoListCollection.document(key.toString()).delete();
  }

  Stream<QuerySnapshot> getUserTodoSnapshot({String uid}) {
    print(uid);
    CollectionReference userTodoListCollection =
        getUserTodoListCollection(uid: uid);
    return userTodoListCollection.snapshots();
  }

  ///inner info. the friends and to-do lists of the users
  CollectionReference getUserTodoListCollection({String uid}) {
    if (uid == null) {
      return usersCollection.innerInit(myUid).collection('TodoList');
    } else {
      return usersCollection.innerInit(uid).collection('TodoList');
    }
  }

  ///do i have to put friends list on firestore?
  CollectionReference getUserFriendsCollection({String uid}) {
    if (uid == null) {
      return usersCollection.innerInit(myUid).collection('Friends');
    } else {
      return usersCollection.innerInit(uid).collection('Friends');
    }
  }
}

class Collection {
  final String collectionName;
  CollectionReference collectionReference;
  DocumentReference innerDocumentReference;

  Collection({@required this.collectionName});
  init() {
    collectionReference = Firestore.instance.collection(collectionName);
  }

  CollectionReference get getCollection => collectionReference;

  DocumentReference innerInit(String innerDocumentName) {
    innerDocumentReference = collectionReference.document(innerDocumentName);
    return innerDocumentReference;
  }

  DocumentReference get getInnerDocument => innerDocumentReference;

  addDocument({Map<String, dynamic> documentData}) {
    collectionReference.document(documentData['uid']).setData(documentData);
  }
}
