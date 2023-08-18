import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class GroupInMessage extends StatelessWidget {
  const GroupInMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          '〇〇へ所属申請中',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '〇〇へ所属申請を送信しました。承認されるまで今しばらくお待ちください。',
          style: TextStyle(
            color: kBlackColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
