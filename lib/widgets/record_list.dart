import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class RecordList extends StatelessWidget {
  const RecordList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey3Color)),
      ),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '01(月)',
              style: TextStyle(color: kBlackColor),
            ),
            Text(
              '00:00〜00:00',
              style: TextStyle(color: kBlackColor),
            ),
            Text(
              '00:00',
              style: TextStyle(color: kBlackColor),
            ),
          ],
        ),
      ),
    );
  }
}
