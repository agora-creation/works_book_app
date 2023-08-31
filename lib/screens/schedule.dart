import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/plan.dart';
import 'package:works_book_app/screens/schedule_add.dart';
import 'package:works_book_app/screens/schedule_data_source.dart';
import 'package:works_book_app/screens/schedule_mod.dart';
import 'package:works_book_app/services/plan.dart';
import 'package:works_book_app/widgets/custom_sf_calendar.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';

class ScheduleScreen extends StatefulWidget {
  final GroupModel group;

  const ScheduleScreen({
    required this.group,
    super.key,
  });

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  PlanService planService = PlanService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: planService.streamList(widget.group.number),
        builder: (context, snapshot) {
          List<PlanModel> plans = [];
          if (snapshot.hasData) {
            for (DocumentSnapshot<Map<String, dynamic>> doc
                in snapshot.data!.docs) {
              plans.add(PlanModel.fromSnapshot(doc));
            }
          }
          return Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 16,
            ),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: CustomSfCalendar(
                  dataSource: ScheduleDataSource(plans),
                  onTap: (CalendarTapDetails details) async {
                    dynamic appointment = details.appointments;
                    DateTime dateTime = details.date!;
                    if (appointment != null) {
                      showDialog(
                        context: context,
                        builder: (context) => PlanDetailsDialog(
                          plan: appointment.first,
                        ),
                      );
                    } else {
                      pushScreen(
                        context,
                        ScheduleAddScreen(
                          group: widget.group,
                          dateTime: dateTime,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PlanDetailsDialog extends StatefulWidget {
  final PlanModel plan;

  const PlanDetailsDialog({
    required this.plan,
    super.key,
  });

  @override
  State<PlanDetailsDialog> createState() => _PlanDetailsDialogState();
}

class _PlanDetailsDialogState extends State<PlanDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.plan.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.plan.details),
          const SizedBox(height: 8),
          Text(
            '作成日時: ${dateText('yyyy/MM/dd HH:mm', widget.plan.createdAt)}',
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 14,
            ),
          ),
          Text(
            '作成者: ${widget.plan.createdUser}',
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSubButton(
                label: '閉じる',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomSubButton(
                label: '編集',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: () => pushScreen(
                  context,
                  ScheduleModScreen(plan: widget.plan),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
