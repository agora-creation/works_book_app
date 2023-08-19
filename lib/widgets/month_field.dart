import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class MonthField extends StatelessWidget {
  final Function()? onTap;

  const MonthField({
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        '2023年08月',
        style: TextStyle(color: kGreyColor),
      ),
      trailing: const Icon(
        Icons.calendar_month,
        color: kGreyColor,
      ),
      onTap: onTap,
    );
  }
}
