import 'package:flutter/material.dart';
import 'package:works_book_app/common/functions.dart';
import 'package:works_book_app/common/style.dart';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  String memo = '';

  void _init() async {
    String tmpMemo = await getPrefsString('memo') ?? '';
    setState(() {
      memo = tmpMemo;
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBackColor,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          TextField(
            autofocus: true,
            controller: TextEditingController(text: memo),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              color: kBlackColor,
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'ここは自分専用のメモ帳です。\n内容はアプリ内にのみ保存され、\n他の人に共有されることはありません。',
              helperStyle: TextStyle(
                color: kGreyColor,
                fontSize: 16,
              ),
            ),
            cursorColor: kBaseColor,
            onChanged: (value) async {
              await setPrefsString('memo', value);
            },
          ),
        ],
      ),
    );
  }
}
