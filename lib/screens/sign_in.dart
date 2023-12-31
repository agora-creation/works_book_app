import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/screens/home.dart';
import 'package:works_book_app/screens/sign_up.dart';
import 'package:works_book_app/widgets/custom_card.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/link_text.dart';
import 'package:works_book_app/widgets/title_logo.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const SizedBox(height: 40),
              const TitleLogo(),
              const SizedBox(height: 80),
              CustomCard(
                children: [
                  CustomTextFormField(
                    controller: userProvider.emailController,
                    textInputType: TextInputType.emailAddress,
                    maxLines: 1,
                    label: '登録したメールアドレス',
                    color: kBaseColor,
                    prefix: Icons.mail,
                  ),
                  const SizedBox(height: 8),
                  CustomTextFormField(
                    controller: userProvider.passwordController,
                    obscureText: true,
                    textInputType: TextInputType.visiblePassword,
                    maxLines: 1,
                    label: '登録したパスワード',
                    color: kBaseColor,
                    prefix: Icons.password,
                  ),
                  const SizedBox(height: 8),
                  errorText != null
                      ? Text('$errorText', style: kErrorStyle)
                      : Container(),
                  CustomMainButton(
                    label: 'ログイン',
                    labelColor: kWhiteColor,
                    backgroundColor: kBaseColor,
                    onPressed: () async {
                      String? error = await userProvider.signIn();
                      if (error != null) {
                        setState(() {
                          errorText = error;
                        });
                        return;
                      }
                      userProvider.clearController();
                      if (!mounted) return;
                      pushReplacementScreen(context, const HomeScreen());
                    },
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: LinkText(
                      label: 'アカウント登録',
                      labelColor: kBaseColor,
                      onTap: () => pushScreen(
                        context,
                        const SignUpScreen(),
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
