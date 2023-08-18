import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class GroupNotMessage extends StatelessWidget {
  const GroupNotMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          '会社・組織に所属していません',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'このアカウントは、会社・組織に所属していません。下のボタンをタップして、所属申請を行ってください。',
          style: TextStyle(
            color: kBlackColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
