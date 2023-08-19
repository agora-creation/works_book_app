import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/group_list.dart';

class GroupInfoScreen extends StatefulWidget {
  final GroupModel? group;

  const GroupInfoScreen({
    this.group,
    super.key,
  });

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
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
        title: const Text('会社・組織情報'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          GroupList(
            headline: '会社・組織番号',
            value: widget.group?.number ?? '',
          ),
          GroupList(
            headline: '会社・組織名',
            value: widget.group?.name ?? '',
          ),
          GroupList(
            headline: '郵便番号',
            value: widget.group?.zipCode ?? '',
          ),
          GroupList(
            headline: '住所',
            value: widget.group?.address ?? '',
          ),
          GroupList(
            headline: '電話番号',
            value: widget.group?.tel ?? '',
          ),
          GroupList(
            headline: 'メールアドレス',
            value: widget.group?.email ?? '',
          ),
          const SizedBox(height: 16),
          CustomMainButton(
            label: 'この会社・組織から脱退する',
            labelColor: kWhiteColor,
            backgroundColor: kRedColor,
            onPressed: () async {
              await userProvider.clearGroup();
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
