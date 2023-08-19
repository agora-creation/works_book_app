import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/widgets/bottom_right_button.dart';

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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
