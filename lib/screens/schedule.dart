import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/plan.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/services/plan.dart';
import 'package:works_book_app/widgets/bottom_right_button.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_schedule_view.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/date_field.dart';
import 'package:works_book_app/widgets/time_field.dart';

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
  List<Appointment> plans = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
              bottom: 40,
            ),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: planService.streamList(widget.group.number),
                  builder: (context, snapshot) {
                    plans.clear();
                    if (snapshot.hasData) {
                      for (DocumentSnapshot<Map<String, dynamic>> doc
                          in snapshot.data!.docs) {
                        PlanModel plan = PlanModel.fromSnapshot(doc);
                        plans.add(Appointment(
                          startTime: plan.startedAt,
                          endTime: plan.endedAt,
                          subject: plan.title,
                          notes: plan.details,
                          color: plan.color,
                          isAllDay: plan.allDay,
                          id: plan.id,
                        ));
                      }
                    }
                    return CustomScheduleView(
                      plans: plans,
                      onTap: (CalendarTapDetails details) async {
                        dynamic appointment = details.appointments;
                        if (appointment != null) {
                          showDialog(
                            context: context,
                            builder: (context) => PlanDetailsDialog(
                              plan: appointment.first,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          BottomRightButton(
            heroTag: 'addPlan',
            iconData: Icons.add,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => PlanAddDialog(
                group: widget.group,
                dateTime: DateTime.now(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlanAddDialog extends StatefulWidget {
  final GroupModel group;
  final DateTime dateTime;

  const PlanAddDialog({
    required this.group,
    required this.dateTime,
    super.key,
  });

  @override
  State<PlanAddDialog> createState() => _PlanAddDialogState();
}

class _PlanAddDialogState extends State<PlanAddDialog> {
  PlanService planService = PlanService();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  String color = kPlanColors.first.value.toRadixString(16);
  bool allDay = false;

  void _init() {
    setState(() {
      startedAt = widget.dateTime;
      endedAt = startedAt.add(const Duration(hours: 1));
    });
  }

  void _allDayChange(bool value) {
    setState(() {
      allDay = value;
      if (value) {
        startedAt = DateTime(
          startedAt.year,
          startedAt.month,
          startedAt.day,
          0,
          0,
          0,
        );
        endedAt = DateTime(
          endedAt.year,
          endedAt.month,
          endedAt.day,
          23,
          59,
          59,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: titleController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: 'タイトル',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: detailsController,
            textInputType: TextInputType.multiline,
            maxLines: null,
            label: '詳細',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: kGreyColor),
          SwitchListTile(
            value: allDay,
            title: const Text('終日'),
            onChanged: _allDayChange,
          ),
          const Text(
            '開始日時',
            style: TextStyle(
              color: kGrey2Color,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              DateField(
                value: startedAt,
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: startedAt,
                    firstDate: kFirstDate,
                    lastDate: kLastDate,
                  );
                  if (selected == null) return;
                  setState(() {
                    startedAt = rebuildDate(selected, startedAt);
                  });
                },
              ),
              const SizedBox(width: 8),
              TimeField(
                value: startedAt,
                onTap: () async {
                  String initTime = dateText('HH:mm', startedAt);
                  List<String> hourMinute = initTime.split(':');
                  final selected = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: int.parse(hourMinute.first),
                      minute: int.parse(hourMinute.last),
                    ),
                  );
                  if (selected == null) return;
                  if (!mounted) return;
                  String selectedTime = selected.format(context);
                  setState(() {
                    startedAt = rebuildTime(
                      context,
                      startedAt,
                      selectedTime,
                    );
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '終了日時',
            style: TextStyle(
              color: kGrey2Color,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              DateField(
                value: endedAt,
                onTap: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: endedAt,
                    firstDate: kFirstDate,
                    lastDate: kLastDate,
                  );
                  if (selected == null) return;
                  setState(() {
                    endedAt = rebuildDate(selected, endedAt);
                  });
                },
              ),
              const SizedBox(width: 8),
              TimeField(
                value: endedAt,
                onTap: () async {
                  String initTime = dateText('HH:mm', endedAt);
                  List<String> hourMinute = initTime.split(':');
                  final selected = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(
                      hour: int.parse(hourMinute.first),
                      minute: int.parse(hourMinute.last),
                    ),
                  );
                  if (selected == null) return;
                  if (!mounted) return;
                  String selectedTime = selected.format(context);
                  setState(() {
                    endedAt = rebuildTime(context, endedAt, selectedTime);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: kGreyColor),
          const SizedBox(height: 8),
          const Text(
            '色',
            style: TextStyle(
              color: kGrey2Color,
              fontSize: 14,
            ),
          ),
          DropdownButton(
            value: color,
            onChanged: (value) {
              setState(() {
                color = value!;
              });
            },
            items: kPlanColors.map((Color value) {
              return DropdownMenuItem(
                value: value.value.toRadixString(16),
                child: Container(
                  color: value,
                  width: 50,
                  height: 25,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Center(
            child: CustomMainButton(
              label: '追加する',
              labelColor: kWhiteColor,
              backgroundColor: kBaseColor,
              onPressed: () async {
                if (titleController.text == '') return;
                String id = planService.id();
                planService.create({
                  'id': id,
                  'groupNumber': widget.group.number,
                  'title': titleController.text,
                  'details': detailsController.text,
                  'startedAt': startedAt,
                  'endedAt': endedAt,
                  'color': color,
                  'allDay': allDay,
                  'createdUser': userProvider.user?.name,
                  'createdAt': DateTime.now(),
                });
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlanDetailsDialog extends StatefulWidget {
  final Appointment plan;

  const PlanDetailsDialog({
    required this.plan,
    super.key,
  });

  @override
  State<PlanDetailsDialog> createState() => _PlanDetailsDialogState();
}

class _PlanDetailsDialogState extends State<PlanDetailsDialog> {
  PlanService planService = PlanService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.plan.color,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.plan.subject,
            style: const TextStyle(
              color: kWhiteColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.plan.notes ?? '',
            style: const TextStyle(
              color: kWhiteColor,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          widget.plan.isAllDay
              ? Text(
                  '予定日: ${dateText('MM/dd', widget.plan.startTime)}',
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                  ),
                )
              : Text(
                  '予定日: ${dateText('MM/dd HH:mm', widget.plan.startTime)}～${dateText('MM/dd HH:mm', widget.plan.endTime)}',
                  style: const TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                  ),
                ),
          const SizedBox(height: 16),
          Center(
            child: CustomSubButton(
              label: 'この予定を削除',
              labelColor: kRedColor,
              backgroundColor: kWhiteColor,
              onPressed: () async {
                planService.delete({'id': widget.plan.id});
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
