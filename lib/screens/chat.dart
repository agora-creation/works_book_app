import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/message.dart';
import 'package:works_book_app/models/user.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/services/fm.dart';
import 'package:works_book_app/services/message.dart';
import 'package:works_book_app/services/user.dart';
import 'package:works_book_app/widgets/bottom_right_button.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/message_list.dart';

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
  MessageService messageService = MessageService();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Container(
      color: kBackColor,
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: messageService.streamList(widget.group.number),
            builder: (context, snapshot) {
              List<MessageModel> messages = [];
              if (snapshot.hasData) {
                for (DocumentSnapshot<Map<String, dynamic>> doc
                    in snapshot.data!.docs) {
                  messages.add(MessageModel.fromSnapshot(doc));
                }
              }
              if (messages.isEmpty) {
                return const Center(child: Text('メッセージがありません'));
              }
              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  bottom: 70,
                ),
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  MessageModel message = messages[index];
                  return MessageList(
                    message: message,
                    isMe: message.userId == userProvider.user?.id,
                  );
                },
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // BottomRightButton(
              //   heroTag: 'addPicture',
              //   iconData: Icons.add_photo_alternate,
              //   onPressed: () {},
              // ),
              BottomRightButton(
                heroTag: 'addMessage',
                iconData: Icons.add_comment,
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => AddMessageDialog(group: widget.group),
                ),
              ),
            ],
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
  FmServices fmServices = FmServices();
  MessageService messageService = MessageService();
  UserService userService = UserService();
  TextEditingController contentController = TextEditingController();

  Future _groupNotification(String body) async {
    List<UserModel> users = await userService.selectList(widget.group.number);
    for (UserModel user in users) {
      fmServices.send(
        token: user.token,
        title: '新着メッセージ',
        body: body,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: contentController,
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
                  String id = messageService.id();
                  messageService.create({
                    'id': id,
                    'groupNumber': widget.group.number,
                    'userId': userProvider.user?.id,
                    'userName': userProvider.user?.name,
                    'content': contentController.text,
                    'createdAt': DateTime.now(),
                  });
                  await _groupNotification(contentController.text);
                  if (!mounted) return;
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
