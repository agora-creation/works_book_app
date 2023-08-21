import 'package:flutter/material.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';

class MonthField extends StatelessWidget {
  final DateTime month;
  final Function()? onTap;

  const MonthField({
    required this.month,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: kBackColor,
      title: Text(
        dateText('yyyy年MM月', month),
        style: const TextStyle(color: kBlackColor),
      ),
      trailing: const Icon(
        Icons.calendar_month,
        color: kGreyColor,
      ),
      onTap: onTap,
    );
  }
}
