import 'package:cloud_firestore/cloud_firestore.dart';

class PlanModel {
  String _id = '';
  String _groupNumber = '';
  String _name = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  bool _allDay = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupNumber => _groupNumber;
  String get name => _name;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  bool get allDay => _allDay;
  DateTime get createdAt => _createdAt;

  PlanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupNumber = map['groupNumber'] ?? '';
    _name = map['name'] ?? '';
    if (map['startedAt'] != null) {
      _startedAt = map['startedAt'].toDate() ?? DateTime.now();
    }
    if (map['endedAt'] != null) {
      _endedAt = map['endedAt'].toDate() ?? DateTime.now();
    }
    _allDay = map['allDay'] ?? false;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }

  PlanModel.fromMap(Map data) {
    _id = data['id'] ?? '';
    _groupNumber = data['groupNumber'] ?? '';
    _name = data['name'] ?? '';
    _startedAt = data['startedAt'] ?? DateTime.now();
    _endedAt = data['endedAt'] ?? DateTime.now();
    _allDay = data['allDay'] ?? false;
    _createdAt = data['createdAt'] ?? DateTime.now();
  }
}
