import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/group_login.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/screens/chat.dart';
import 'package:works_book_app/screens/group_in.dart';
import 'package:works_book_app/screens/memo.dart';
import 'package:works_book_app/screens/record.dart';
import 'package:works_book_app/screens/schedule.dart';
import 'package:works_book_app/screens/settings.dart';
import 'package:works_book_app/screens/todo.dart';
import 'package:works_book_app/services/group.dart';
import 'package:works_book_app/services/group_login.dart';
import 'package:works_book_app/widgets/custom_persistent_tab_view.dart';
import 'package:works_book_app/widgets/home_widget1.dart';
import 'package:works_book_app/widgets/home_widget2.dart';
import 'package:works_book_app/widgets/home_widget3.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GroupService groupService = GroupService();
  GroupLoginService groupLoginService = GroupLoginService();
  PersistentTabController? controller;

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return StreamBuilder2<QuerySnapshot<Map<String, dynamic>>,
        QuerySnapshot<Map<String, dynamic>>>(
      streams: StreamTuple2(
        groupService.streamList(userProvider.user?.groupNumber),
        groupLoginService.streamList(userProvider.user?.id),
      ),
      builder: (context, snapshot) {
        GroupModel? group;
        if (snapshot.snapshot1.hasData) {
          for (DocumentSnapshot<Map<String, dynamic>> doc
              in snapshot.snapshot1.data!.docs) {
            group = GroupModel.fromSnapshot(doc);
          }
        }
        GroupLoginModel? groupLogin;
        if (snapshot.snapshot2.hasData) {
          for (DocumentSnapshot<Map<String, dynamic>> doc
              in snapshot.snapshot2.data!.docs) {
            groupLogin = GroupLoginModel.fromSnapshot(doc);
          }
        }
        Widget? titleWidget;
        Widget? bodyWidget;
        if (group != null) {
          titleWidget = Text(group.name);
          bodyWidget = CustomPersistentTabView(
            context: context,
            controller: controller,
            screens: const [
              ScheduleScreen(),
              TodoScreen(),
              RecordScreen(),
              ChatScreen(),
              MemoScreen(),
            ],
            items: [
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.calendar_month),
                title: 'スケジュール',
                activeColorPrimary: kBaseColor,
                inactiveColorPrimary: kGrey2Color,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.checklist),
                title: 'Todo',
                activeColorPrimary: kBaseColor,
                inactiveColorPrimary: kGrey2Color,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.timer),
                title: '打刻',
                activeColorPrimary: kBaseColor,
                inactiveColorPrimary: kGrey2Color,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.chat),
                title: 'チャット',
                activeColorPrimary: kBaseColor,
                inactiveColorPrimary: kGrey2Color,
              ),
              PersistentBottomNavBarItem(
                icon: const Icon(Icons.edit_note),
                title: 'メモ',
                activeColorPrimary: kBaseColor,
                inactiveColorPrimary: kGrey2Color,
              ),
            ],
          );
        } else {
          if (groupLogin == null) {
            bodyWidget = HomeWidget1(
              onPressed: () => showBottomUpScreen(
                context,
                const GroupInScreen(),
              ),
            );
          } else {
            if (groupLogin.accept == false) {
              bodyWidget = HomeWidget2(groupLogin: groupLogin);
            } else {
              bodyWidget = HomeWidget3(
                groupLogin: groupLogin,
                onPressed: () async {
                  await userProvider.reloadUser();
                },
              );
            }
          }
        }
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: titleWidget,
            actions: [
              IconButton(
                onPressed: () => showBottomUpScreen(
                  context,
                  SettingsScreen(group: group),
                ),
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: bodyWidget,
        );
      },
    );
  }
}
