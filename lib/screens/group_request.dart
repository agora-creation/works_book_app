import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/group_login.dart';
import 'package:works_book_app/services/group_login.dart';
import 'package:works_book_app/services/user.dart';
import 'package:works_book_app/widgets/group_login_list.dart';

class GroupRequestScreen extends StatefulWidget {
  final GroupModel? group;

  const GroupRequestScreen({
    this.group,
    super.key,
  });

  @override
  State<GroupRequestScreen> createState() => _GroupRequestScreenState();
}

class _GroupRequestScreenState extends State<GroupRequestScreen> {
  GroupLoginService groupLoginService = GroupLoginService();
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('会社・組織のログイン申請'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: groupLoginService.streamListRequest(widget.group?.number),
        builder: (context, snapshot) {
          List<GroupLoginModel> groupLogins = [];
          if (snapshot.hasData) {
            for (DocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.data!.docs) {
              groupLogins.add(GroupLoginModel.fromSnapshot(doc));
            }
          }
          if (groupLogins.isEmpty) {
            return const Center(child: Text('ログイン申請がありません'));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: groupLogins.length,
            itemBuilder: (context, index) {
              GroupLoginModel groupLogin = groupLogins[index];
              return GroupLoginList(
                groupLogin: groupLogin,
                acceptOnPressed: () {
                  groupLoginService.update({
                    'id': groupLogin.id,
                    'accept': true,
                  });
                  userService.update({
                    'id': groupLogin.id,
                    'groupNumber': groupLogin.groupNumber,
                  });
                },
                rejectOnPressed: () {
                  groupLoginService.delete({'id': groupLogin.id});
                },
              );
            },
          );
        },
      ),
    );
  }
}
