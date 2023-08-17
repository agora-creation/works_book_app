import 'package:flutter/material.dart';

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
          'このアカウントは、会社・組織に所属していません。以下のボタンをタップして、所属を行ってください。',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
