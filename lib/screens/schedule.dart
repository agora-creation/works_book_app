import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/plan.dart';
import 'package:works_book_app/screens/schedule_add.dart';
import 'package:works_book_app/screens/schedule_data_source.dart';
import 'package:works_book_app/screens/schedule_mod.dart';

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
                DateTime dateTime = details.date!;
                if (appointment != null) {
                  await showBottomUpScreen(
                    context,
                    const ScheduleModScreen(),
                  );
                } else {
                  await showBottomUpScreen(
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
      ),
    );
  }
}
