import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
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
            child: Text('打刻'),
          ),
        ),
      ),
    );
  }
}
