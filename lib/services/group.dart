import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_app/models/group.dart';

class GroupService {
  String collection = 'group';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<GroupModel?> select(String? loginId) async {
    GroupModel? ret;
    await firestore
        .collection(collection)
        .where('loginId', isEqualTo: loginId ?? 'error')
        .get()
        .then((value) {
      ret = GroupModel.fromSnapshot(value.docs.first);
    });
    return ret;
  }
}
