import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';

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
            padding: const EdgeInsets.all(16),
            child: SfCalendar(
              view: CalendarView.week,
            ),
          ),
        ),
      ),
    );
  }
}
