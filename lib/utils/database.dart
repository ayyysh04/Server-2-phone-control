import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference mainCollection = _firestore.collection('users');

class Database {
  Database() {
    add();
  }
  static String? userUid;

  static Future<void> add() async {
    DocumentReference documentReferencer = mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      "action": Null,
      "data": {
        "body": 'Email body',
        "subject": 'Email subject',
        "recipients": ['example@example.com'],
        "cc": ['cc@example.com'],
        "bcc": ['bcc@example.com'],
        "to": "ayushiit2003@gmail.com",
      },
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> addItem({
    required String title,
    required String description,
  }) async {
    DocumentReference documentReferencer =
        mainCollection.doc(userUid).collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        mainCollection.doc(userUid).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
        mainCollection.doc(userUid).collection('items');

    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
