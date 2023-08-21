import 'package:flutter/material.dart';

class ScheduleModScreen extends StatefulWidget {
  const ScheduleModScreen({super.key});

  @override
  State<ScheduleModScreen> createState() => _ScheduleModScreenState();
}

class _ScheduleModScreenState extends State<ScheduleModScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('予定の変更'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
