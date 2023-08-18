import 'package:cloud_firestore/cloud_firestore.dart';

class GroupLoginService {
  String collection = 'groupLogin';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamList(String? id) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(id ?? 'error')
        .snapshots();
  }
}
