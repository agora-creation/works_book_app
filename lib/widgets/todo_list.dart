import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/todo.dart';

class TodoList extends StatelessWidget {
  final TodoModel todo;
  final Function(bool?)? onChanged;
  final Function()? onTap;

  const TodoList({
    required this.todo,
    this.onChanged,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: todo.finished == true ? kGrey3Color : null,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Checkbox(
              value: todo.finished,
              onChanged: onChanged,
              fillColor: MaterialStateProperty.all(kBaseColor),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Text(
                  todo.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: kBlackColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
