// ignore_for_file: use_build_context_synchronously

import 'package:battleships/helpers/alert_helper.dart';
import 'package:battleships/helpers/api_helper.dart';
import 'package:battleships/helpers/dialog_helper.dart';
import 'package:battleships/main.dart';
import 'package:battleships/models/game_detail_response.dart';
import 'package:battleships/models/games_model.dart';
import 'package:battleships/utils/global_values.dart';
import 'package:battleships/views/game_screen.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  List<Game> games = [];
  List<Game> completedGames = [], activeGames = [];
  bool showHistory = false;

  void newGame() {
    Navigator.of(context).push(CupertinoPageRoute(
        builder: (context) => GameScreen(
              isNewGame: true,
              ai: "",
              gameDetail: GameDetailsResponse.fromJson({}),
            )));
  }

  void newGamewithAI(bool mounted) async {
    try {
      String option = await DialogHelper().pickAIType() ?? "";
      if (option.isNotEmpty && mounted) {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => GameScreen(
                isNewGame: true,
                ai: option,
                gameDetail: GameDetailsResponse.fromJson({}))));
      }
    } catch (e) {
      NotificationHelper().showErrorNotification(e.toString());
    }
  }

  void logout() async {
    var pref = await SharedPreferences.getInstance();
    pref.remove("access_token");
    pref.remove("username");
    pref.remove("password");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  void showGameStatus(index) async {
    try {
      var game = await APIHelper()
          .gameDetails(games[index].id, GlobalValues.accessToken);
      Navigator.of(context).push(CupertinoPageRoute(
          builder: (context) => GameScreen(
                isNewGame: false,
                ai: "",
                gameDetail: game,
              )));
    } catch (e) {
      NotificationHelper().showErrorNotification(e.toString());
    }
  }

  Future<void> showCompletedGames() async {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        DialogHelper().loader();
        games = await APIHelper().getAllGames(GlobalValues.accessToken);
        completedGames = games
            .where((element) => element.status == 1 || element.status == 2)
            .toList();
        activeGames = games
            .where((element) => element.status == 0 || element.status == 3)
            .toList();
        if (showHistory) {
          games = completedGames.toList();
        } else {
          games = activeGames.toList();
        }
        Navigator.pop(context);
        notifyListeners();
      });
    } catch (e) {
      Navigator.pop(context);
      NotificationHelper().showErrorNotification(e.toString());
    }
  }

  void displayHistory() async {
    showHistory = true;
    await showCompletedGames();
    Navigator.pop(context);
  }

  void showAtive() async {
    showHistory = false;
    await showCompletedGames();
    Navigator.pop(context);
  }

  void deleteGame(DismissDirection direction, int id) async {
    try {
      DialogHelper().loader();
      String message =
          await APIHelper().deleteGame(id, GlobalValues.accessToken);
      games.removeWhere((element) => element.id == id);
      Navigator.pop(context);
      NotificationHelper().showErrorNotification(message, useImage: true);
    } catch (e) {
      NotificationHelper().showErrorNotification(e.toString());
    }
  }
}
