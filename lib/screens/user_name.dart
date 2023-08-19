import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';

class UserNameScreen extends StatefulWidget {
  final UserProvider userProvider;

  const UserNameScreen({
    required this.userProvider,
    super.key,
  });

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  String? errorText;

  @override
  void initState() {
    super.initState();
    widget.userProvider.nameController.text =
        widget.userProvider.user?.name ?? '';
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
        title: const Text('お名前変更'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CustomTextFormField(
            controller: widget.userProvider.nameController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: 'お名前',
            color: kBaseColor,
            prefix: Icons.person,
          ),
          const SizedBox(height: 16),
          errorText != null
              ? Text('$errorText', style: kErrorStyle)
              : Container(),
          CustomMainButton(
            label: '変更内容を保存',
            labelColor: kWhiteColor,
            backgroundColor: kBaseColor,
            onPressed: () async {
              String? error = await widget.userProvider.updateUserName();
              if (error != null) {
                setState(() {
                  errorText = error;
                });
                return;
              }
              widget.userProvider.clearController();
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
