import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Card(
                elevation: 8,
                child: CheckboxListTile(
                  value: false,
                  title: const Text('Todo'),
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Card(
                elevation: 8,
                child: CheckboxListTile(
                  value: true,
                  title: const Text('Todo'),
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Card(
                elevation: 8,
                child: CheckboxListTile(
                  value: false,
                  title: const Text('Todo'),
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              Card(
                elevation: 8,
                child: CheckboxListTile(
                  value: false,
                  title: const Text('Todo'),
                  onChanged: (value) {},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
