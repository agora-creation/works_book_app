import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class TimeField extends StatelessWidget {
  const TimeField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: const Row(
        children: [
          Text(
            '00:00',
            style: TextStyle(color: kBlackColor),
          ),
          SizedBox(width: 16),
          Icon(
            Icons.access_time,
            color: kGreyColor,
          ),
        ],
      ),
    );
  }
}
