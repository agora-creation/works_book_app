import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/models/record.dart';

class RecordService {
  String collection = 'record';
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

  Future<RecordModel?> select(String? id) async {
    RecordModel? ret;
    await firestore.collection(collection).doc(id).get().then((value) {
      ret = RecordModel.fromSnapshot(value);
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList({
    required DateTime month,
    required String groupNumber,
    String? userId,
  }) {
    DateTime monthStart = DateTime(month.year, month.month, 1);
    DateTime monthEnd = DateTime(month.year, month.month + 1, 1).add(
      const Duration(days: -1),
    );
    Timestamp startAt = convertTimestamp(monthStart, false);
    Timestamp endAt = convertTimestamp(monthEnd, true);
    return FirebaseFirestore.instance
        .collection(collection)
        .where('groupNumber', isEqualTo: groupNumber)
        .where('userId', isEqualTo: userId ?? 'error')
        .orderBy('startedAt', descending: false)
        .startAt([startAt]).endAt([endAt]).snapshots();
  }
}
