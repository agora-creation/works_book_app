import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/widgets/bottom_right_button.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/month_field.dart';
import 'package:works_book_app/widgets/record_list.dart';
import 'package:works_book_app/widgets/record_list_header.dart';

class RecordScreen extends StatefulWidget {
  final GroupModel group;

  const RecordScreen({
    required this.group,
    super.key,
  });

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 48,
            ),
            child: Card(
              elevation: 8,
              child: Column(
                children: [
                  MonthField(
                    onTap: () {},
                  ),
                  const Divider(height: 0, color: kGreyColor),
                  const RecordListHeader(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return const RecordList();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomRightButton(
            iconData: Icons.more_time,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddRecordDialog(group: widget.group),
            ),
          ),
        ],
      ),
    );
  }
}

class AddRecordDialog extends StatefulWidget {
  final GroupModel group;

  const AddRecordDialog({
    required this.group,
    super.key,
  });

  @override
  State<AddRecordDialog> createState() => _AddRecordDialogState();
}

class _AddRecordDialogState extends State<AddRecordDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '2023年08月19日(火)',
            style: TextStyle(color: kGrey2Color),
          ),
          const Text(
            '00:00:00',
            style: TextStyle(
              color: kBaseColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          CustomMainButton(
            label: '出勤する',
            labelColor: kWhiteColor,
            backgroundColor: kBlueColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
