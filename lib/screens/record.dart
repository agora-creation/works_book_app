import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/record.dart';
import 'package:works_book_app/models/record_rest.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/services/record.dart';
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
  RecordService recordService = RecordService();
  DateTime selectedMonth = DateTime.now();
  List<DateTime> days = [];

  void changeMonth(DateTime month) {
    setState(() {
      selectedMonth = month;
      days = generateDays(selectedMonth);
    });
  }

  @override
  void initState() {
    super.initState();
    changeMonth(selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
                    month: selectedMonth,
                    onTap: () async {
                      var selected = await showMonthPicker(
                        context: context,
                        initialDate: selectedMonth,
                      );
                      if (selected != null) {
                        changeMonth(selected);
                      }
                    },
                  ),
                  const Divider(height: 0, color: kGreyColor),
                  const RecordListHeader(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: recordService.streamList(
                        month: selectedMonth,
                        groupNumber: widget.group.number,
                        userId: userProvider.user?.id,
                      ),
                      builder: (context, snapshot) {
                        List<RecordModel> records = [];
                        if (snapshot.hasData) {
                          for (DocumentSnapshot<Map<String, dynamic>> doc
                              in snapshot.data!.docs) {
                            records.add(RecordModel.fromSnapshot(doc));
                          }
                        }
                        return ListView.builder(
                          itemCount: days.length,
                          itemBuilder: (context, index) {
                            List<RecordModel> dayInRecords = [];
                            for (RecordModel record in records) {
                              String key =
                                  dateText('yyyy-MM-dd', record.startedAt);
                              if (days[index] == DateTime.parse(key)) {
                                dayInRecords.add(record);
                              }
                            }
                            return RecordList(
                              day: days[index],
                              dayInRecords: dayInRecords,
                            );
                          },
                        );
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
  RecordService recordService = RecordService();
  String date = '----/--/--(-)';
  String time = '--:--:--';

  void _onTimer(Timer timer) {
    DateTime now = DateTime.now();
    if (mounted) {
      setState(() {
        date = dateText('yyyy/MM/dd(E)', now);
        time = dateText('HH:mm:ss', now);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 1),
      _onTimer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isRecord = false;
    bool isRecordRest = false;
    if (userProvider.user?.recordId != '') {
      isRecord = true;
      if (userProvider.user?.recordRestId != '') {
        isRecordRest = true;
      }
    }
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            date,
            style: const TextStyle(color: kGrey2Color),
          ),
          Text(
            time,
            style: const TextStyle(
              color: kBaseColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
            ),
          ),
          const SizedBox(height: 16),
          !isRecord && !isRecordRest
              ? CustomMainButton(
                  label: '出勤する',
                  labelColor: kWhiteColor,
                  backgroundColor: kBlueColor,
                  onPressed: () async {
                    String id = recordService.id();
                    recordService.create({
                      'id': id,
                      'groupNumber': widget.group.number,
                      'userId': userProvider.user?.id,
                      'startedAt': DateTime.now(),
                      'endedAt': DateTime.now(),
                      'recordRests': [],
                      'createdAt': DateTime.now(),
                    });
                    userProvider.updateRecordId(id);
                    await userProvider.reloadUser();
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                )
              : Container(),
          isRecord && !isRecordRest
              ? Column(
                  children: [
                    CustomMainButton(
                      label: '退勤する',
                      labelColor: kWhiteColor,
                      backgroundColor: kRedColor,
                      onPressed: () async {
                        recordService.update({
                          'id': userProvider.user?.recordId,
                          'endedAt': DateTime.now(),
                        });
                        userProvider.updateRecordId('');
                        await userProvider.reloadUser();
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                    ),
                    CustomMainButton(
                      label: '休憩する',
                      labelColor: kWhiteColor,
                      backgroundColor: kOrangeColor,
                      onPressed: () async {
                        RecordModel? record = await recordService.select(
                          userProvider.user?.recordId,
                        );
                        if (record == null) return;
                        List<Map> recordRests = [];
                        for (RecordRestModel recordRest in record.recordRests) {
                          recordRests.add(recordRest.toMap());
                        }
                        String id = rndText(20);
                        recordRests.add({
                          'id': id,
                          'startedAt': DateTime.now(),
                          'endedAt': DateTime.now(),
                        });
                        recordService.update({
                          'id': userProvider.user?.recordId,
                          'recordRests': recordRests,
                        });
                        userProvider.updateRecordRestId(id);
                        await userProvider.reloadUser();
                        if (!mounted) return;
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              : Container(),
          isRecord && isRecordRest
              ? CustomMainButton(
                  label: '休憩終了',
                  labelColor: kWhiteColor,
                  backgroundColor: kOrangeColor,
                  onPressed: () async {
                    RecordModel? record = await recordService.select(
                      userProvider.user?.recordId,
                    );
                    if (record == null) return;
                    List<Map> recordRests = [];
                    for (RecordRestModel recordRest in record.recordRests) {
                      if (recordRest.id == userProvider.user?.recordRestId) {
                        recordRest.endedAt = DateTime.now();
                      }
                      recordRests.add(recordRest.toMap());
                    }
                    recordService.update({
                      'id': userProvider.user?.recordId,
                      'recordRests': recordRests,
                    });
                    userProvider.updateRecordRestId('');
                    await userProvider.reloadUser();
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                )
              : Container(),
        ],
      ),
    );
  }
}
