import 'package:flutter/material.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/plan.dart';
import 'package:works_book_app/services/plan.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/date_field.dart';
import 'package:works_book_app/widgets/link_text.dart';
import 'package:works_book_app/widgets/time_field.dart';

class ScheduleModScreen extends StatefulWidget {
  final PlanModel plan;

  const ScheduleModScreen({
    required this.plan,
    super.key,
  });

  @override
  State<ScheduleModScreen> createState() => _ScheduleModScreenState();
}

class _ScheduleModScreenState extends State<ScheduleModScreen> {
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('予定の変更'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
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
              Center(
                child: CustomMainButton(
                  label: '変更する',
                  labelColor: kWhiteColor,
                  backgroundColor: kBaseColor,
                  onPressed: () async {
                    if (nameController.text == '') return;
                    planService.update({
                      'id': widget.plan.id,
                      'name': nameController.text,
                      'startedAt': startedAt,
                      'endedAt': endedAt,
                      'color': color,
                      'allDay': allDay,
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: LinkText(
                  label: 'この予定を削除する',
                  labelColor: kRedColor,
                  onTap: () async {
                    planService.delete({'id': widget.plan.id});
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
