import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/screens/group_info.dart';
import 'package:works_book_app/screens/sign_in.dart';
import 'package:works_book_app/screens/user_email.dart';
import 'package:works_book_app/screens/user_name.dart';
import 'package:works_book_app/screens/user_password.dart';
import 'package:works_book_app/widgets/link_text.dart';
import 'package:works_book_app/widgets/settings_list_tile.dart';
import 'package:works_book_app/widgets/title_logo.dart';

class SettingsScreen extends StatefulWidget {
  final GroupModel? group;

  const SettingsScreen({
    this.group,
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('各種設定'),
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
          children: [
            const TitleLogo(),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Ver 1.0.0',
                style: TextStyle(
                  color: kGrey2Color,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SettingsListTile(
              iconData: Icons.person,
              label: 'お名前変更',
              topBorder: true,
              onTap: () => pushScreen(
                context,
                UserNameScreen(userProvider: userProvider),
              ),
            ),
            SettingsListTile(
              iconData: Icons.email,
              label: 'メールアドレス変更',
              onTap: () => pushScreen(
                context,
                UserEmailScreen(userProvider: userProvider),
              ),
            ),
            SettingsListTile(
              iconData: Icons.password,
              label: 'パスワード変更',
              onTap: () => pushScreen(
                context,
                UserPasswordScreen(userProvider: userProvider),
              ),
            ),
            widget.group != null
                ? SettingsListTile(
                    iconData: Icons.groups,
                    label: '会社・組織情報',
                    onTap: () => pushScreen(
                      context,
                      GroupInfoScreen(group: widget.group),
                    ),
                  )
                : Container(),
            const SizedBox(height: 24),
            LinkText(
              label: 'ログアウト',
              labelColor: kRedColor,
              onTap: () async {
                await userProvider.signOut();
                userProvider.clearController();
                if (!mounted) return;
                pushReplacementScreen(context, const SignInScreen());
              },
            ),
            const SizedBox(height: 16),
            LinkText(
              label: 'アカウント削除',
              labelColor: kRedColor,
              onTap: () async {
                await userProvider.delete();
                userProvider.clearController();
                if (!mounted) return;
                pushReplacementScreen(context, const SignInScreen());
              },
            ),
          ],
        ),
      ),
    );
  }
}
