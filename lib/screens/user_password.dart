import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';

class UserPasswordScreen extends StatefulWidget {
  final UserProvider userProvider;

  const UserPasswordScreen({
    required this.userProvider,
    super.key,
  });

  @override
  State<UserPasswordScreen> createState() => _UserPasswordScreenState();
}

class _UserPasswordScreenState extends State<UserPasswordScreen> {
  String? errorText;

  @override
  void initState() {
    super.initState();
    widget.userProvider.passwordController.text =
        widget.userProvider.user?.password ?? '';
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
        title: const Text('パスワード変更'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CustomTextFormField(
            controller: widget.userProvider.passwordController,
            obscureText: true,
            textInputType: TextInputType.visiblePassword,
            maxLines: 1,
            label: 'パスワード',
            color: kBaseColor,
            prefix: Icons.password,
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
              String? error = await widget.userProvider.updateUserPassword();
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
