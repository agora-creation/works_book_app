import 'package:flutter/material.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';

class UserEmailScreen extends StatefulWidget {
  final UserProvider userProvider;

  const UserEmailScreen({
    required this.userProvider,
    super.key,
  });

  @override
  State<UserEmailScreen> createState() => _UserEmailScreenState();
}

class _UserEmailScreenState extends State<UserEmailScreen> {
  String? errorText;

  @override
  void initState() {
    super.initState();
    widget.userProvider.emailController.text =
        widget.userProvider.user?.email ?? '';
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
        title: const Text('メールアドレス変更'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          CustomTextFormField(
            controller: widget.userProvider.emailController,
            textInputType: TextInputType.emailAddress,
            maxLines: 1,
            label: 'メールアドレス',
            color: kBaseColor,
            prefix: Icons.mail,
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
              String? error = await widget.userProvider.updateUserEmail();
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
