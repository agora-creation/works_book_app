import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: const Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 16,
        ),
        child: Card(
          elevation: 8,
          child: Center(
            child: Text('スケジュール'),
          ),
        ),
      ),
    );
  }
}
