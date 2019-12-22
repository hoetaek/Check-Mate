import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class TodoFirestoreProvider {
  final String uid;
  TodoFirestoreProvider({this.uid});

  Collection usersCollection;
  Collection myCollection;
  Collection friendCollection;
  init() {
    usersCollection = Collection(collectionName: "Users");
    usersCollection.init();
    myCollection = Collection(collectionName: uid);
    myCollection.init();
  }

  Future<List<dynamic>> getUsersNicknameData() async {
    QuerySnapshot usersData = await getUsersData();
    for (DocumentSnapshot doc in usersData.documents) {
      print(doc.data["nickname"]);
    }
    return usersData.documents.map((data) => data.data["nickname"]).toList();
  }

  Stream<QuerySnapshot> getUsersNicknameSnapshot() {
    return usersCollection.getCollection().snapshots();
  }

  Future<List<dynamic>> getUsersUidData() async {
    QuerySnapshot usersData = await getUsersData();
    return usersData.documents.map((data) => data.data["uid"]).toList();
  }

  Future<QuerySnapshot> getUsersData() async =>
      await usersCollection.getCollection().getDocuments();

  addUsersData(Map<String, dynamic> userData) {
    usersCollection.addDocument(documentData: userData);
  }

  getMyFriends() {
    myCollection.getInnerCollection('friend').getDocuments();
  }

//  getFriendTodoCollection(String friendUid) {
//    friendCollection = Firestore.instance.collection(friendUid);
//    return friendCollection.document('todo').collection('todo');
//  }
}

class Collection {
  final String collectionName;
  CollectionReference collectionReference;
  CollectionReference innerCollectionReference;

  Collection({@required this.collectionName});
  init() {
    collectionReference = Firestore.instance.collection(collectionName);
  }

  CollectionReference getCollection() {
    return collectionReference;
  }

  innerInit(String innerCollectionName) {
    innerCollectionReference = collectionReference
        .document(innerCollectionName)
        .collection(innerCollectionName);
  }

  CollectionReference getInnerCollection(String innerCollectionName) {
    return innerCollectionReference;
  }

  Future addDocument({Map<String, dynamic> documentData}) async {
    return await collectionReference.document().setData(documentData);
  }

  addInnerDocument({Map documentData}) {
    innerCollectionReference.add(documentData);
  }
}
