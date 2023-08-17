import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';
import 'package:works_book_app/providers/user.dart';
import 'package:works_book_app/screens/chat.dart';
import 'package:works_book_app/screens/group_in.dart';
import 'package:works_book_app/screens/memo.dart';
import 'package:works_book_app/screens/record.dart';
import 'package:works_book_app/screens/schedule.dart';
import 'package:works_book_app/screens/settings.dart';
import 'package:works_book_app/screens/todo.dart';
import 'package:works_book_app/widgets/custom_main_button.dart';
import 'package:works_book_app/widgets/custom_persistent_tab_view.dart';
import 'package:works_book_app/widgets/group_not_message.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController? controller;
  List<Widget> buildScreens() {
    return [
      const ScheduleScreen(),
      const TodoScreen(),
      const RecordScreen(),
      const ChatScreen(),
      const MemoScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
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
    ];
  }

  @override
  void initState() {
    super.initState();
    controller = PersistentTabController(initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: userProvider.group != null
            ? Text(userProvider.group?.name ?? '')
            : null,
        actions: [
          IconButton(
            onPressed: () => showBottomUpScreen(
              context,
              const SettingsScreen(),
            ),
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: userProvider.group != null
          ? CustomPersistentTabView(
              context: context,
              controller: controller,
              screens: buildScreens(),
              items: navBarsItems(),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const GroupNotMessage(),
                  CustomMainButton(
                    label: '会社・組織に所属する',
                    labelColor: kWhiteColor,
                    backgroundColor: kBaseColor,
                    onPressed: () => showBottomUpScreen(
                      context,
                      const GroupInScreen(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
