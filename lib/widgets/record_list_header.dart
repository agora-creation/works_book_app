import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class RecordListHeader extends StatelessWidget {
  const RecordListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kGrey3Color,
        border: Border(bottom: BorderSide(color: kGrey3Color)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '日付',
              style: TextStyle(color: kBlackColor),
            ),
            Text(
              '出勤〜退勤',
              style: TextStyle(color: kBlackColor),
            ),
            Text(
              '勤務時間',
              style: TextStyle(color: kBlackColor),
            ),
          ],
        ),
      ),
    );
  }
}
