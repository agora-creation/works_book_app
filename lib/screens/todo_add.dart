import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/services/todo.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';

class TodoAddScreen extends StatefulWidget {
  final GroupModel group;

  const TodoAddScreen({
    required this.group,
    super.key,
  });

  @override
  State<TodoAddScreen> createState() => _TodoAddScreenState();
}

class _TodoAddScreenState extends State<TodoAddScreen> {
  TodoService todoService = TodoService();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text('Todoを追加'),
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
            label: '上記内容で追加する',
            labelColor: kWhiteColor,
            backgroundColor: kBaseColor,
            onPressed: () async {
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
        ],
      ),
    );
  }
}
