import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TodoFirestoreProvider {
  final String myUid;
  TodoFirestoreProvider({this.myUid});
  Collection usersCollection;

  init() {
    usersCollection = Collection(collectionName: "Users");
    usersCollection.init();
  }

  addUsersData(Map<String, dynamic> userData) {
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
      return usersCollection.innerInit(myUid).collection('TodoList');
    } else {
      return usersCollection.innerInit(uid).collection('TodoList');
    }
  }
}

class Collection {
  final String collectionName;
  CollectionReference collectionReference;
  DocumentReference innerCollectionReference;

  Collection({@required this.collectionName});
  init() {
    collectionReference = Firestore.instance.collection(collectionName);
  }

  CollectionReference get getCollection => collectionReference;

  DocumentReference innerInit(String innerDocumentName) {
    innerCollectionReference = collectionReference.document(innerDocumentName);
  }

  DocumentReference get getInnerDocument => innerCollectionReference;

  Future addDocument({Map<String, dynamic> documentData}) async {
    return await collectionReference.document().setData(documentData);
  }

//  addInnerDocument({Map documentData}) {
//    innerCollectionReference.add(documentData);
//  }
}
