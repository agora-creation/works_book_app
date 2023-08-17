import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/screens/home.dart';
import 'package:works_book_app/screens/sign_in.dart';
import 'package:works_book_app/widgets/custom_card.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/link_text.dart';
import 'package:works_book_app/widgets/title_logo.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const TitleLogo(),
              CustomCard(
                children: [
                  CustomTextFormField(
                    controller: userProvider.nameController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                    label: 'お名前',
                    color: kBaseColor,
                    prefix: Icons.person,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: userProvider.emailController,
                    textInputType: TextInputType.emailAddress,
                    maxLines: 1,
                    label: 'メールアドレス',
                    color: kBaseColor,
                    prefix: Icons.mail,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: userProvider.passwordController,
                    obscureText: true,
                    textInputType: TextInputType.visiblePassword,
                    maxLines: 1,
                    label: 'パスワード',
                    color: kBaseColor,
                    prefix: Icons.password,
                  ),
                  const SizedBox(height: 8),
                  CustomMainButton(
                    label: '新規登録',
                    labelColor: kWhiteColor,
                    backgroundColor: kBaseColor,
                    onPressed: () async {
                      String? error = await userProvider.signUp();
                      if (error != null) {
                        return;
                      }
                      userProvider.clearController();
                      if (!mounted) return;
                      pushReplacementScreen(context, const HomeScreen());
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: LinkText(
                      label: 'ログイン',
                      labelColor: kBaseColor,
                      onTap: () => pushScreen(
                        context,
                        const SignInScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
