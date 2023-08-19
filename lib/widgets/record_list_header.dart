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
          children: [
            Text(
              '日付',
              style: TextStyle(
                color: kBlackColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 28),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '出勤時間',
                    style: TextStyle(
                      color: kBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '退勤時間',
                    style: TextStyle(
                      color: kBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '勤務時間',
                    style: TextStyle(
                      color: kBlackColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
