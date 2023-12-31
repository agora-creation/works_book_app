import 'package:flutter/material.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/message.dart';

class MessageList extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final Function()? onTapImage;

  const MessageList({
    required this.message,
    required this.isMe,
    this.onTapImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (isMe) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            message.imageUrl == ''
                ? Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: kBaseColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(
                        message.content,
                        style: const TextStyle(color: kWhiteColor),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: onTapImage,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kBaseColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          message.imageUrl,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.userName,
              style: const TextStyle(
                color: kGrey2Color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            message.imageUrl == ''
                ? Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(8),
                    color: kWhiteColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(message.content),
                    ),
                  )
                : GestureDetector(
                    onTap: onTapImage,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      color: kWhiteColor,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          message.imageUrl,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
            Text(
              dateText('MM/dd HH:mm', message.createdAt),
              style: const TextStyle(
                color: kGreyColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
  }
}
