import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';

class GroupInScreen extends StatefulWidget {
  const GroupInScreen({super.key});

  @override
  State<GroupInScreen> createState() => _GroupInScreenState();
}

class _GroupInScreenState extends State<GroupInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('会社・組織に所属する'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextFormField(
              controller: TextEditingController(),
              textInputType: TextInputType.text,
              maxLines: 1,
              label: '会社・組織番号',
              color: kBaseColor,
              prefix: Icons.key,
            ),
            const SizedBox(height: 8),
            CustomMainButton(
              label: '番号チェック',
              labelColor: kWhiteColor,
              backgroundColor: kBaseColor,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
