import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group_login.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';

class HomeWidget3 extends StatelessWidget {
  final GroupLoginModel? groupLogin;
  final Function()? onPressed;

  const HomeWidget3({
    this.groupLogin,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                '所属申請が承認されました',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${groupLogin?.groupName}への所属申請が承認されました。下のボタンをタップして、利用を開始してください。',
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          CustomMainButton(
            label: '利用開始',
            labelColor: kWhiteColor,
            backgroundColor: kBaseColor,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
