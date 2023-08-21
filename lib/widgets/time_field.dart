import 'package:flutter/material.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';

class TimeField extends StatelessWidget {
  final DateTime value;
  final Function()? onTap;

  const TimeField({
    required this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Text(
              dateText('HH:mm', value),
              style: const TextStyle(color: kBlackColor),
            ),
            const SizedBox(width: 16),
            const Icon(
              Icons.access_time,
              color: kGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
