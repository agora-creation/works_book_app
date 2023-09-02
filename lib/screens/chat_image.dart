import 'package:flutter/material.dart';

class ChatImageScreen extends StatefulWidget {
  final String imageUrl;

  const ChatImageScreen({
    required this.imageUrl,
    super.key,
  });

  @override
  State<ChatImageScreen> createState() => _ChatImageScreenState();
}

class _ChatImageScreenState extends State<ChatImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: InteractiveViewer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
