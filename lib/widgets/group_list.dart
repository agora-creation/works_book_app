import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';

class GroupList extends StatelessWidget {
  final String headline;
  final String value;
  final Function()? onPressed;

  const GroupList({
    required this.headline,
    required this.value,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey2Color)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headline,
                  style: const TextStyle(
                    color: kGrey2Color,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: kBlackColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onPressed != null
                ? CustomSubButton(
                    label: 'キャンセル',
                    labelColor: kWhiteColor,
                    backgroundColor: kGreyColor,
                    onPressed: onPressed,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
