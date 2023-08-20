import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  String collection = 'message';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id() {
    return firestore.collection(collection).doc().id;
  }

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList(String? groupNumber) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('groupNumber', isEqualTo: groupNumber ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
