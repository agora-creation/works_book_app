import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/todo.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/services/todo.dart';
import 'package:works_book_app/widgets/bottom_right_button.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/link_text.dart';
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
            onPressed: () => showDialog(
              context: context,
              builder: (context) => TodoAddDialog(
                group: widget.group,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TodoAddDialog extends StatefulWidget {
  final GroupModel group;

  const TodoAddDialog({
    required this.group,
    super.key,
  });

  @override
  State<TodoAddDialog> createState() => _TodoAddDialogState();
}

class _TodoAddDialogState extends State<TodoAddDialog> {
  TodoService todoService = TodoService();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: titleController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: 'タイトル',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 8),
          CustomTextFormField(
            controller: detailsController,
            textInputType: TextInputType.multiline,
            maxLines: null,
            label: '詳細',
            color: kBlackColor,
            prefix: Icons.short_text,
          ),
          const SizedBox(height: 16),
          Center(
            child: CustomMainButton(
              label: '追加する',
              labelColor: kWhiteColor,
              backgroundColor: kBaseColor,
              onPressed: () async {
                if (titleController.text == '') return;
                String id = todoService.id();
                todoService.create({
                  'id': id,
                  'groupNumber': widget.group.number,
                  'title': titleController.text,
                  'details': detailsController.text,
                  'finished': false,
                  'createdUser': userProvider.user?.name,
                  'createdAt': DateTime.now(),
                });
                Navigator.pop(context);
              },
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
  TodoService todoService = TodoService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.todo.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.todo.details,
            style: const TextStyle(fontSize: 16),
          ),
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
          const SizedBox(height: 16),
          Center(
            child: LinkText(
              label: 'このTodoを削除',
              labelColor: kRedColor,
              onTap: () async {
                todoService.delete({'id': widget.todo.id});
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
