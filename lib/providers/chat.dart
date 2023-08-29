import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:works_book_app/models/group.dart';
import 'package:works_book_app/models/user.dart';
import 'package:works_book_app/services/fm.dart';
import 'package:works_book_app/services/message.dart';
import 'package:works_book_app/services/user.dart';

class ChatProvider with ChangeNotifier {
  FmServices fmServices = FmServices();
  MessageService messageService = MessageService();
  UserService userService = UserService();

  Future<String?> sendMessage({
    required GroupModel group,
    required UserModel? user,
    required String content,
  }) async {
    String? error;
    if (content == '') error = 'メッセージを入力してください';
    try {
      String id = messageService.id();
      messageService.create({
        'id': id,
        'groupNumber': group.number,
        'userId': user?.id,
        'userName': user?.name,
        'content': content,
        'imageUrl': '',
        'createdAt': DateTime.now(),
      });
      await _groupNotification(
        group: group,
        body: content,
      );
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> sendImage({
    required GroupModel group,
    required UserModel? user,
    required File imageFile,
  }) async {
    String? error;
    try {
      String id = messageService.id();
      FirebaseStorage storage = FirebaseStorage.instance;
      final task =
          await storage.ref('chat/${group.number}/$id').putFile(imageFile);
      String imageUrl = await task.ref.getDownloadURL();
      messageService.create({
        'id': id,
        'groupNumber': group.number,
        'userId': user?.id,
        'userName': user?.name,
        'content': '',
        'imageUrl': imageUrl,
        'createdAt': DateTime.now(),
      });
      await _groupNotification(
        group: group,
        body: '画像を送信しました。',
      );
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future _groupNotification({
    required GroupModel group,
    required String body,
  }) async {
    List<UserModel> users = await userService.selectList(group.number);
    for (UserModel user in users) {
      fmServices.send(
        token: user.token,
        title: '新着メッセージ',
        body: body,
      );
    }
  }
}
