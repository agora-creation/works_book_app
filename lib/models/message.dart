import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String _id = '';
  String _groupNumber = '';
  String _userId = '';
  String _userName = '';
  String _content = '';
  String _imageUrl = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupNumber => _groupNumber;
  String get userId => _userId;
  String get userName => _userName;
  String get content => _content;
  String get imageUrl => _imageUrl;
  DateTime get createdAt => _createdAt;

  MessageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupNumber = map['groupNumber'] ?? '';
    _userId = map['userId'] ?? '';
    _userName = map['userName'] ?? '';
    _content = map['content'] ?? '';
    _imageUrl = map['imageUrl'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
