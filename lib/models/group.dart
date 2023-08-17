import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String _id = '';
  String _name = '';
  String _zipCode = '';
  String _address = '';
  String _tel = '';
  String _email = '';
  String _loginId = '';
  String _password = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get name => _name;
  String get zipCode => _zipCode;
  String get address => _address;
  String get tel => _tel;
  String get email => _email;
  String get loginId => _loginId;
  String get password => _password;
  DateTime get createdAt => _createdAt;

  GroupModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _name = map['name'] ?? '';
    _zipCode = map['zipCode'] ?? '';
    _address = map['address'] ?? '';
    _tel = map['tel'] ?? '';
    _email = map['email'] ?? '';
    _loginId = map['loginId'] ?? '';
    _password = map['password'] ?? '';
    _createdAt = map['createdAt'].toDate() ?? DateTime.now();
  }
}
