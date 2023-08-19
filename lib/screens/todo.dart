import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/todo.dart';
import 'package:works_book_app/services/todo.dart';
import 'package:works_book_app/widgets/bottom_right_button.dart';
import 'package:works_book_app/widgets/custom_sub_button.dart';
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
                  left: 16,
                  right: 16,
                  bottom: 32,
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
                      builder: (context) => ModTodoDialog(todo: todo),
                    ),
                  );
                },
              );
            },
          ),
          BottomRightButton(
            iconData: Icons.add,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AddTodoDialog(group: widget.group),
            ),
          ),
        ],
      ),
    );
  }
}

class AddTodoDialog extends StatefulWidget {
  final GroupModel group;

  const AddTodoDialog({
    required this.group,
    super.key,
  });

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  TodoService todoService = TodoService();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: contentController,
            textInputType: TextInputType.multiline,
            maxLines: null,
            label: '追加する内容',
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
                label: 'Todoを追加する',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: () async {
                  String id = todoService.id();
                  todoService.create({
                    'id': id,
                    'groupNumber': widget.group.number,
                    'content': contentController.text,
                    'finished': false,
                    'createdAt': DateTime.now(),
                  });
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

class ModTodoDialog extends StatefulWidget {
  final TodoModel todo;

  const ModTodoDialog({
    required this.todo,
    super.key,
  });

  @override
  State<ModTodoDialog> createState() => _ModTodoDialogState();
}

class _ModTodoDialogState extends State<ModTodoDialog> {
  TodoService todoService = TodoService();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contentController.text = widget.todo.content;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: contentController,
            textInputType: TextInputType.multiline,
            maxLines: null,
            label: '変更する内容',
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
                label: '変更内容を保存',
                labelColor: kWhiteColor,
                backgroundColor: kBaseColor,
                onPressed: () async {
                  todoService.update({
                    'id': widget.todo.id,
                    'content': contentController.text,
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: LinkText(
              label: 'Todoを削除',
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
