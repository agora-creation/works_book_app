import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/services/plan.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/date_field.dart';
import 'package:works_book_app/widgets/time_field.dart';

class ScheduleAddScreen extends StatefulWidget {
  final GroupModel group;
  final DateTime dateTime;

  const ScheduleAddScreen({
    required this.group,
    required this.dateTime,
    super.key,
  });

  @override
  State<ScheduleAddScreen> createState() => _ScheduleAddScreenState();
}

class _ScheduleAddScreenState extends State<ScheduleAddScreen> {
  PlanService planService = PlanService();
  TextEditingController nameController = TextEditingController();
  String color = kPlanColors.first.value.toRadixString(16);
  bool allDay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('予定の追加'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
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
              onChanged: (value) {
                setState(() {
                  allDay = value;
                });
              },
            ),
            const Text(
              '開始日時',
              style: TextStyle(
                color: kGrey2Color,
                fontSize: 14,
              ),
            ),
            const Row(
              children: [
                DateField(),
                SizedBox(width: 8),
                TimeField(),
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
            const Row(
              children: [
                DateField(),
                SizedBox(width: 8),
                TimeField(),
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
                  String id = planService.id();
                  planService.create({
                    'id': id,
                    'groupNumber': widget.group.number,
                    'name': nameController.text,
                    'startedAt': DateTime.now(),
                    'endedAt': DateTime.now(),
                    'color': color,
                    'allDay': allDay,
                    'createdAt': DateTime.now(),
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
