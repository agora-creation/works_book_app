import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/widgets/bottom_right_button.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';

class ChatScreen extends StatefulWidget {
  final GroupModel group;

  const ChatScreen({
    required this.group,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: Stack(
        children: [
          BottomRightButton(
            iconData: Icons.add_comment,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddMessageDialog(group: widget.group),
            ),
          ),
        ],
      ),
    );
  }
}

class AddMessageDialog extends StatefulWidget {
  final GroupModel group;

  const AddMessageDialog({
    required this.group,
    super.key,
  });

  @override
  State<AddMessageDialog> createState() => _AddMessageDialogState();
}

class _AddMessageDialogState extends State<AddMessageDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: TextEditingController(),
            textInputType: TextInputType.multiline,
            maxLines: null,
            label: 'メッセージを入力',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSubButton(
                label: 'やめる',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomSubButton(
                label: '送信する',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
