import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';

class GroupList extends StatelessWidget {
  final GroupModel? group;
  final Function()? onPressed;

  const GroupList({
    required this.group,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: kGrey2Color),
          bottom: BorderSide(color: kGrey2Color),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '会社・組織名',
                  style: TextStyle(
                    color: kGrey2Color,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'アゴラ・クリエーション',
                  style: TextStyle(
                    color: kBaseColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            CustomSubButton(
              label: 'キャンセル',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }
}
