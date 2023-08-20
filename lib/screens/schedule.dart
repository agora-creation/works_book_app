import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/plan.dart';
import 'package:works_book_app/screens/schedule_data_source.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';

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
  List<PlanModel> _getDataSource() {
    List<PlanModel> plans = [];
    plans.add(PlanModel.fromMap({
      'id': '1',
      'groupNumber': widget.group.number,
      'name': 'テスト',
      'startedAt': DateTime.now(),
      'endedAt': DateTime.now().add(const Duration(hours: 2)),
      'allDay': false,
      'createdAt': DateTime.now(),
    }));
    plans.add(PlanModel.fromMap({
      'id': '2',
      'groupNumber': widget.group.number,
      'name': 'テスト',
      'startedAt': DateTime.now().add(const Duration(hours: 1)),
      'endedAt': DateTime.now().add(const Duration(hours: 4)),
      'allDay': false,
      'createdAt': DateTime.now(),
    }));
    plans.add(PlanModel.fromMap({
      'id': '3',
      'groupNumber': widget.group.number,
      'name': 'テストテストテストテストテスト',
      'startedAt': DateTime.now().add(const Duration(hours: 6)),
      'endedAt': DateTime.now().add(const Duration(hours: 9)),
      'allDay': false,
      'createdAt': DateTime.now(),
    }));
    return plans;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 16,
        ),
        child: Card(
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SfCalendar(
              view: CalendarView.week,
              allowedViews: const [
                CalendarView.day,
                CalendarView.week,
                CalendarView.month,
              ],
              dataSource: ScheduleDataSource(_getDataSource()),
              selectionDecoration: BoxDecoration(
                color: kBaseColor.withOpacity(0.1),
                border: Border.all(color: kBaseColor, width: 2),
                shape: BoxShape.rectangle,
              ),
              headerDateFormat: 'yyyy年MM月',
              onTap: (CalendarTapDetails details) async {
                dynamic appointment = details.appointments;
                DateTime date = details.date!;
                await showDialog(
                  context: context,
                  builder: (context) => const AddScheduleDialog(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AddScheduleDialog extends StatefulWidget {
  const AddScheduleDialog({super.key});

  @override
  State<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
          Text('開始日'),
          Text('開始時間'),
          Text('終了日'),
          Text('終了時間'),
          Text('終日'),
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
