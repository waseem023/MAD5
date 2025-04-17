// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:battleships/helpers/alert_helper.dart';
import 'package:battleships/helpers/api_helper.dart';
import 'package:battleships/helpers/dialog_helper.dart';
import 'package:battleships/main.dart';
import 'package:battleships/utils/global_values.dart';
import 'package:battleships/views/home_screen.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  bool startUp = false;

  void startupInitialization() async {
    await loadAccessToken();
    Future.delayed(const Duration(seconds: 5), () {
      if (GlobalValues.accessToken.isNotEmpty) {
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => const Homescreen()));
      } else {
        Navigator.of(context).pushReplacement(
            CupertinoPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  void register() async {
    try {
      startUp = true;
      bool usernamePass = username.text.isNotEmpty && username.text.length >= 3;
      bool passwordPass = password.text.isNotEmpty && password.text.length >= 3;
      if (usernamePass && passwordPass) {
        DialogHelper().loader();
        var response = await APIHelper().register(username.text, password.text);
        NotificationHelper().showSuccessNotification(response['message']);
        GlobalValues.username = username.text;
        GlobalValues.accessToken = response["access_token"];
        await saveLocal();
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => const Homescreen()));
      }
    } catch (e) {
      NotificationHelper().showErrorNotification(e.toString());
    }
    notifyListeners();
  }

  void login() async {
    try {
      startUp = true;
      bool usernamePass = username.text.isNotEmpty && username.text.length >= 3;
      bool passwordPass = password.text.isNotEmpty && password.text.length >= 3;
      if (usernamePass && passwordPass) {
        DialogHelper().loader();
        var response = await APIHelper().login(username.text, password.text);
        NotificationHelper().showSuccessNotification(response['message']);
        GlobalValues.username = username.text;
        GlobalValues.accessToken = response["access_token"];
        await saveLocal();
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            CupertinoPageRoute(builder: (context) => const Homescreen()));
      }
    } catch (e) {
      NotificationHelper().showErrorNotification(e.toString());
      Navigator.pop(context);
    }
    notifyListeners();
  }

  Future<void> saveLocal() async {
    var pref = await SharedPreferences.getInstance();
    await pref.setString('access_token', GlobalValues.accessToken);
    await pref.setString('username', username.text);
    await pref.setString('password', password.text);
  }

  Future<void> loadAccessToken() async {
    var pref = await SharedPreferences.getInstance();
    GlobalValues.accessToken = pref.getString('access_token') ?? "";
    GlobalValues.username = pref.getString('username') ?? "";
  }
}
