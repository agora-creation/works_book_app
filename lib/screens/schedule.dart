import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/plan.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/screens/schedule_data_source.dart';
import 'package:works_book_app/services/plan.dart';
import 'package:works_book_app/widgets/custom_sf_calendar.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/date_field.dart';
import 'package:works_book_app/widgets/link_text.dart';
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
                      await showDialog(
                        context: context,
                        builder: (context) => ModPlanDialog(
                          plan: appointment.first,
                        ),
                      );
                    } else {
                      await showDialog(
                        context: context,
                        builder: (context) => AddPlanDialog(
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

class AddPlanDialog extends StatefulWidget {
  final GroupModel group;
  final DateTime dateTime;

  const AddPlanDialog({
    required this.group,
    required this.dateTime,
    super.key,
  });

  @override
  State<AddPlanDialog> createState() => _AddPlanDialogState();
}

class _AddPlanDialogState extends State<AddPlanDialog> {
  PlanService planService = PlanService();
  TextEditingController nameController = TextEditingController();
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
            controller: nameController,
            textInputType: TextInputType.text,
            maxLines: 1,
            label: '予定名',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSubButton(
                label: 'やめる',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomSubButton(
                label: '予定を追加する',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: () async {
                  if (nameController.text == '') return;
                  String id = planService.id();
                  planService.create({
                    'id': id,
                    'groupNumber': widget.group.number,
                    'userId': userProvider.user?.id,
                    'userName': userProvider.user?.name,
                    'name': nameController.text,
                    'details': '',
                    'startedAt': startedAt,
                    'endedAt': endedAt,
                    'color': color,
                    'allDay': allDay,
                    'createdAt': DateTime.now(),
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ModPlanDialog extends StatefulWidget {
  final PlanModel plan;

  const ModPlanDialog({
    required this.plan,
    super.key,
  });

  @override
  State<ModPlanDialog> createState() => _ModPlanDialogState();
}

class _ModPlanDialogState extends State<ModPlanDialog> {
  PlanService planService = PlanService();
  TextEditingController nameController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  String color = kPlanColors.first.value.toRadixString(16);
  bool allDay = false;

  void _init() {
    setState(() {
      nameController.text = widget.plan.name;
      startedAt = widget.plan.startedAt;
      endedAt = widget.plan.endedAt;
      color = widget.plan.color.value.toRadixString(16);
      allDay = widget.plan.allDay;
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
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: nameController,
            textInputType: TextInputType.text,
            maxLines: 1,
            label: '予定名',
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
          const SizedBox(height: 8),
          const Text(
            '作成日時',
            style: TextStyle(
              color: kGrey2Color,
              fontSize: 14,
            ),
          ),
          Text(
            dateText('yyyy/MM/dd HH:mm', widget.plan.createdAt),
            style: const TextStyle(color: kBlackColor),
          ),
          const SizedBox(height: 8),
          const Text(
            '作成者',
            style: TextStyle(
              color: kGrey2Color,
              fontSize: 14,
            ),
          ),
          Text(
            widget.plan.userName,
            style: const TextStyle(color: kBlackColor),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSubButton(
                label: 'やめる',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomSubButton(
                label: '変更内容を保存',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: () async {
                  if (nameController.text == '') return;
                  planService.update({
                    'id': widget.plan.id,
                    'name': nameController.text,
                    'details': '',
                    'startedAt': startedAt,
                    'endedAt': endedAt,
                    'color': color,
                    'allDay': allDay,
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: LinkText(
              label: '予定を削除',
              labelColor: kRedColor,
              onTap: () async {
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
