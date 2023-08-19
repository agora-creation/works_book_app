import 'package:flutter/material.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/record.dart';

class RecordList extends StatelessWidget {
  final DateTime day;
  final List<RecordModel> dayInRecords;

  const RecordList({
    required this.day,
    required this.dayInRecords,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> startEndTexts = [];
    List<Widget> recordTexts = [];
    for (RecordModel dayInRecord in dayInRecords) {
      String startEndText = '';
      String recordText = '';
      if (dayInRecord.startedAt == dayInRecord.endedAt) {
        startEndText = '${dayInRecord.startTime()} 〜 --:--';
        recordText = '--:--';
      } else {
        startEndText = '${dayInRecord.startTime()} 〜 ${dayInRecord.endTime()}';
        recordText = dayInRecord.recordTime();
      }
      startEndTexts.add(Text(
        startEndText,
        style: const TextStyle(color: kBlackColor),
      ));
      recordTexts.add(Text(
        recordText,
        style: const TextStyle(color: kBlackColor),
      ));
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey3Color)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              dateText('dd(E)', day),
              style: const TextStyle(color: kBlackColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                children: dayInRecords.map((record) {
                  String startTimeText = record.startTime();
                  String endTimeText = '';
                  String recordTimeText = '';
                  if (record.startedAt != record.endedAt) {
                    endTimeText = record.endTime();
                    recordTimeText = record.recordTime();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        startTimeText,
                        style: const TextStyle(color: kBlackColor),
                      ),
                      Text(
                        endTimeText,
                        style: const TextStyle(color: kBlackColor),
                      ),
                      Text(
                        recordTimeText,
                        style: const TextStyle(color: kBlackColor),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
