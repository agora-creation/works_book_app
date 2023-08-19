import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:works_book_app/models/user.dart';
import 'package:works_book_app/services/group_login.dart';
import 'package:works_book_app/services/user.dart';

enum AuthStatus {
  authenticated,
  uninitialized,
  authenticating,
  unauthenticated,
}

class UserProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.uninitialized;
  AuthStatus get status => _status;
  FirebaseAuth? auth;
  User? _authUser;
  User? get authUser => _authUser;
  UserService userService = UserService();
  GroupLoginService groupLoginService = GroupLoginService();
  UserModel? _user;
  UserModel? get user => _user;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void clearController() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  UserProvider.initialize() : auth = FirebaseAuth.instance {
    auth?.authStateChanges().listen(_onStateChanged);
  }

  Future<String?> signIn() async {
    String? error;
    if (emailController.text == '') error = 'メールアドレスを入力してください';
    if (passwordController.text == '') error = 'パスワードを入力してください';
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await auth?.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      _authUser = result?.user;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = 'ログインに失敗しました';
    }
    return error;
  }

  Future<String?> signUp() async {
    String? error;
    if (nameController.text == '') error = 'お名前を入力してください';
    if (emailController.text == '') error = 'メールアドレスを入力してください';
    if (passwordController.text == '') error = 'パスワードを入力してください';
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final result = await auth?.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      _authUser = result?.user;
      userService.create({
        'id': _authUser?.uid,
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'groupNumber': '',
        'token': '',
        'createdAt': DateTime.now(),
      });
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      error = 'アカウント登録に失敗しました';
    }
    return error;
  }

  Future<String?> updateUserName() async {
    String? error;
    if (nameController.text == '') error = 'お名前を入力してください';
    try {
      userService.update({
        'id': _authUser?.uid,
        'name': nameController.text,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateUserEmail() async {
    String? error;
    if (emailController.text == '') error = 'メールアドレスを入力してください';
    try {
      await auth?.currentUser?.updateEmail(emailController.text);
      userService.update({
        'id': _authUser?.uid,
        'email': emailController.text,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future<String?> updateUserPassword() async {
    String? error;
    if (passwordController.text == '') error = 'パスワードを入力してください';
    try {
      await auth?.currentUser?.updatePassword(passwordController.text);
      userService.update({
        'id': _authUser?.uid,
        'password': passwordController.text,
      });
    } catch (e) {
      error = e.toString();
    }
    return error;
  }

  Future signOut() async {
    await auth?.signOut();
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future reloadUser() async {
    _user = await userService.select(_authUser?.uid);
    notifyListeners();
  }

  Future clearGroup() async {
    userService.update({
      'id': _authUser?.uid,
      'groupNumber': '',
    });
    groupLoginService.delete({'id': _authUser?.uid});
    _user = await userService.select(_authUser?.uid);
    notifyListeners();
  }

  Future _onStateChanged(User? authUser) async {
    if (authUser == null) {
      _status = AuthStatus.unauthenticated;
    } else {
      _authUser = authUser;
      _status = AuthStatus.authenticated;
      _user = await userService.select(_authUser?.uid);
    }
    notifyListeners();
  }
}
