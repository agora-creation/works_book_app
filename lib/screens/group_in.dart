import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/services/group.dart';
import 'package:works_book_app/services/group_login.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_text_form_field.dart';
import 'package:works_book_app/widgets/group_list.dart';

class GroupInScreen extends StatefulWidget {
  const GroupInScreen({super.key});

  @override
  State<GroupInScreen> createState() => _GroupInScreenState();
}

class _GroupInScreenState extends State<GroupInScreen> {
  GroupService groupService = GroupService();
  GroupLoginService groupLoginService = GroupLoginService();
  GroupModel? group;
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
          children: [
            const Text(
              '所属したい会社や組織から、『会社・組織番号』を確認し、以下に入力してください。',
              style: TextStyle(
                color: kBlackColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              controller: numberController,
              textInputType: TextInputType.number,
              maxLines: 1,
              label: '会社・組織番号',
              color: kBaseColor,
              prefix: Icons.key,
            ),
            const SizedBox(height: 8),
            group == null
                ? Container()
                : GroupList(
                    headline: '会社・組織番号',
                    value: group?.name ?? '',
                    onPressed: () {
                      setState(() {
                        group = null;
                        numberController.clear();
                      });
                    },
                  ),
            const SizedBox(height: 8),
            group == null
                ? const Text('会社・組織が見つかりませんでした', style: kErrorStyle)
                : Container(),
            group == null
                ? CustomMainButton(
                    label: '番号チェック',
                    labelColor: kWhiteColor,
                    backgroundColor: kBaseColor,
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      GroupModel? tmpGroup = await groupService.select(
                        numberController.text,
                      );
                      setState(() {
                        group = tmpGroup;
                      });
                    },
                  )
                : CustomMainButton(
                    label: '所属申請を送る',
                    labelColor: kWhiteColor,
                    backgroundColor: kBaseColor,
                    onPressed: () {
                      groupLoginService.create({
                        'id': userProvider.user?.id,
                        'groupNumber': group?.number,
                        'groupName': group?.name,
                        'userName': userProvider.user?.name,
                        'accept': false,
                        'createdAt': DateTime.now(),
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
