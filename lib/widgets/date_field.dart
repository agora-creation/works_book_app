import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class DateField extends StatelessWidget {
  const DateField({super.key});

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
            '2023/08/21',
            style: TextStyle(color: kBlackColor),
          ),
          SizedBox(width: 16),
          Icon(
            Icons.calendar_today,
            color: kGreyColor,
          ),
        ],
      ),
    );
  }
}
