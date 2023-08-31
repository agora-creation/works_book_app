import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/todo.dart';
import 'package:works_book_app/services/todo.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/link_text.dart';

class TodoModScreen extends StatefulWidget {
  final TodoModel todo;

  const TodoModScreen({
    required this.todo,
    super.key,
  });

  @override
  State<TodoModScreen> createState() => _TodoModScreenState();
}

class _TodoModScreenState extends State<TodoModScreen> {
  TodoService todoService = TodoService();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.todo.title;
    detailsController.text = widget.todo.details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Todoを編集'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
          CustomMainButton(
            label: '変更内容を保存',
            labelColor: kWhiteColor,
            backgroundColor: kBaseColor,
            onPressed: () async {
              todoService.update({
                'id': widget.todo.id,
                'title': titleController.text,
                'details': detailsController.text,
              });
              Navigator.pop(context);
              Navigator.pop(context);
            },
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
