import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';

class HomeWidget1 extends StatelessWidget {
  final Function()? onPressed;

  const HomeWidget1({
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
          const Column(
            children: [
              Text(
                '会社・組織に所属していません',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'このアカウントは、会社・組織に所属していません。下のボタンをタップして、所属申請を行ってください。',
                style: TextStyle(
                  color: kBlackColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          CustomMainButton(
            label: '会社・組織に所属する',
            labelColor: kWhiteColor,
            backgroundColor: kBaseColor,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
