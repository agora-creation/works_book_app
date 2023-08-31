import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/todo.dart';
import 'package:works_book_app/screens/todo_add.dart';
import 'package:works_book_app/screens/todo_mod.dart';
import 'package:works_book_app/services/todo.dart';
import 'package:works_book_app/widgets/bottom_right_button.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';
import 'package:works_book_app/widgets/todo_list.dart';

class TodoScreen extends StatefulWidget {
  final GroupModel group;

  const TodoScreen({
    required this.group,
    super.key,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  TodoService todoService = TodoService();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: todoService.streamList(widget.group.number),
            builder: (context, snapshot) {
              List<TodoModel> todos = [];
              if (snapshot.hasData) {
                for (DocumentSnapshot<Map<String, dynamic>> doc
                    in snapshot.data!.docs) {
                  todos.add(TodoModel.fromSnapshot(doc));
                }
              }
              if (todos.isEmpty) {
                return const Center(child: Text('Todoがありません'));
              }
              return ListView.builder(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  bottom: 40,
                ),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  TodoModel todo = todos[index];
                  return TodoList(
                    todo: todo,
                    onChanged: (value) {
                      todoService.update({
                        'id': todo.id,
                        'finished': value ?? false,
                      });
                    },
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => TodoDetailsDialog(todo: todo),
                    ),
                  );
                },
              );
            },
          ),
          BottomRightButton(
            heroTag: 'addTodo',
            iconData: Icons.add,
            onPressed: () => pushScreen(
              context,
              TodoAddScreen(group: widget.group),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoDetailsDialog extends StatefulWidget {
  final TodoModel todo;

  const TodoDetailsDialog({
    required this.todo,
    super.key,
  });

  @override
  State<TodoDetailsDialog> createState() => _TodoDetailsDialogState();
}

class _TodoDetailsDialogState extends State<TodoDetailsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.todo.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.todo.details),
          const SizedBox(height: 8),
          Text(
            '作成日時: ${dateText('yyyy/MM/dd HH:mm', widget.todo.createdAt)}',
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 14,
            ),
          ),
          Text(
            '作成者: ${widget.todo.createdUser}',
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomSubButton(
                label: '閉じる',
                labelColor: kWhiteColor,
                backgroundColor: kGreyColor,
                onPressed: () => Navigator.pop(context),
              ),
              CustomSubButton(
                label: '編集',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: () => pushScreen(
                  context,
                  TodoModScreen(todo: widget.todo),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
