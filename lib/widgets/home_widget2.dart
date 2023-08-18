import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group_login.dart';

class HomeWidget2 extends StatelessWidget {
  final GroupLoginModel? groupLogin;

  const HomeWidget2({
    this.groupLogin,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '所属申請中',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${groupLogin?.groupName}へ所属申請を送信しました。承認されるまで今しばらくお待ちください。',
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
