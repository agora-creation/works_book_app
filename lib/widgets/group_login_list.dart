import 'package:flutter/material.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group_login.dart';

class GroupLoginList extends StatelessWidget {
  final GroupLoginModel groupLogin;
  final Function()? acceptOnPressed;
  final Function()? rejectOnPressed;

  const GroupLoginList({
    required this.groupLogin,
    this.acceptOnPressed,
    this.rejectOnPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGreyColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupLogin.userName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'ログイン日時 : ${dateText('yyyy/MM/dd HH:mm', groupLogin.createdAt)}',
                  style: const TextStyle(
                    color: kGreyColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: acceptOnPressed,
                style: TextButton.styleFrom(
                  backgroundColor: kBlueColor,
                  padding: const EdgeInsets.all(8),
                ),
                child: const Text(
                  '承認',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              TextButton(
                onPressed: rejectOnPressed,
                style: TextButton.styleFrom(
                  backgroundColor: kRedColor,
                  padding: const EdgeInsets.all(8),
                ),
                child: const Text(
                  '却下',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
