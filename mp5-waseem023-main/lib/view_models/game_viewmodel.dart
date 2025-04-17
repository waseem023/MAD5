// ignore_for_file: use_build_context_synchronously

import 'package:battleships/helpers/alert_helper.dart';
import 'package:battleships/helpers/api_helper.dart';
import 'package:battleships/helpers/dialog_helper.dart';
import 'package:battleships/main.dart';
import 'package:battleships/models/game_detail_response.dart';
import 'package:battleships/models/place_shot_response.dart';
import 'package:battleships/models/set_game_response.dart';
import 'package:battleships/utils/global_values.dart';
import 'package:battleships/views/home_screen.dart';
import 'package:flutter/cupertino.dart';

class GameViewModel extends ChangeNotifier {
  bool visibleSubmitbtn = true;
  List<String> shipSpots = [];
  List<String> shipSunk = [];
  List<String> shipWrek = [];
  List<String> shots = [];
  String selectedShot = "";
  SetGameResponse setGameResponse = SetGameResponse.fromJson({});
  PlaceShotResponse placeShotResponse = PlaceShotResponse.fromJson({});

  void newGame() {
    visibleSubmitbtn = true;
    shipSpots = [];
    shipSunk = [];
    shipWrek = [];
    shots = [];
    selectedShot = "";
  }

  void updateGameDetails(GameDetailsResponse gameDetails) {
    shipSpots = gameDetails.ships;
    shipSunk = gameDetails.sunk;
    shipWrek = gameDetails.wrecks;
    shots = gameDetails.shots;
    visibleSubmitbtn =
        gameDetails.status == 3 && (gameDetails.turn == gameDetails.position);
  }

  void btnSubmitTapped(String option) async {
    try {
      if (shipSpots.length < 5) {
        NotificationHelper()
            .showErrorNotification("Please place all five ships");
        return;
      }
      DialogHelper().loader();
      setGameResponse = await APIHelper()
          .setGame(shipSpots, option, GlobalValues.accessToken);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => const Homescreen()),
          (route) => false);
    } catch (e) {
      NotificationHelper().showErrorNotification(e.toString());
    }
  }

  void shoot(String shot, GameDetailsResponse gameDetails) async {
    try {
      if (shot.isEmpty) {
        NotificationHelper().showErrorNotification("Place a shot");
        return;
      }
      DialogHelper().loader();
      placeShotResponse = await APIHelper()
          .placeShot(gameDetails.id, shot, GlobalValues.accessToken);
      if (placeShotResponse.sunkShip) {
        shipSunk.add(shot);
      } else {
        shots.add(shot);
      }
      gameDetails = await APIHelper()
          .gameDetails(gameDetails.id, GlobalValues.accessToken);
      updateGameDetails(gameDetails);

      if (gameDetails.status == gameDetails.position) {
        await DialogHelper().winnerPopUp(true);
      } else if (gameDetails.status != gameDetails.position &&
          gameDetails.status != 3) {
        await DialogHelper().winnerPopUp(false);
      }
      Navigator.pop(context);
      selectedShot = '';
    } catch (e) {
      Navigator.pop(context);
      NotificationHelper().showErrorNotification(e.toString());
    }
    notifyListeners();
  }

  void chooseShot(String shot) {
    if (shots.contains(shot)) {
      NotificationHelper()
          .showErrorNotification("You have already placed a shot");
      return;
    }
    selectedShot = shot;
    notifyListeners();
  }

  void placeShips(String spots) {
    if (!shipSpots.contains(spots)) {
      if (shipSpots.length < 5) {
        shipSpots.add(spots);
      } else {
        NotificationHelper()
            .showErrorNotification("You have placed all five ships");
      }
    } else {
      shipSpots.remove(spots);
    }
    notifyListeners();
  }
}
