import 'dart:convert';

import 'package:battleships/models/game_detail_response.dart';
import 'package:battleships/models/games_model.dart';
import 'package:battleships/models/place_shot_response.dart';
import 'package:battleships/models/set_game_response.dart';
import 'package:http/http.dart' as http;

class APIHelper {
  String baseURL = 'https://battleships-app.onrender.com';
  Map<String, String> headers() => {"Content-Type": "application/json"};
  Map<String, String> headerswithAuth(String accesstoken) => {
        "Content-Type": "application/json",
        "Authorization": 'Bearer $accesstoken'
      };

  Future<dynamic> register(String username, String password) async {
    Map<String, String> body = {"username": username, "password": password};
    try {
      var response = await http.post(Uri.parse("$baseURL/register"),
          body: jsonEncode(body), headers: headers());
      var parsedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return parsedResponse;
      } else {
        throw parsedResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> login(String username, String password) async {
    Map<String, String> body = {"username": username, "password": password};
    try {
      var response = await http.post(Uri.parse("$baseURL/login"),
          body: jsonEncode(body), headers: headers());
      var parsedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return parsedResponse;
      } else {
        throw parsedResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Game>> getAllGames(String accesstoken) async {
    try {
      var response = await http.get(Uri.parse("$baseURL/games"),
          headers: headerswithAuth(accesstoken));
      if (response.statusCode == 200) {
        dynamic jsonDecode2 = jsonDecode(response.body);
        jsonDecode2 = jsonDecode2['games'];
        return jsonDecode2.map<Game>((item) => Game.fromJson(item)).toList();
      } else {
        tokenExpire(response);
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<SetGameResponse> setGame(
      List<String> ships, String ai, String accesstoken) async {
    try {
      Map<String, dynamic> body = {"ships": ships};
      if (ai.isNotEmpty) body['ai'] = ai.toLowerCase();
      var response = await http.post(Uri.parse("$baseURL/games"),
          headers: headerswithAuth(accesstoken), body: jsonEncode(body));
      if (response.statusCode == 200) {
        return SetGameResponse.fromJson(jsonDecode(response.body));
      } else {
        tokenExpire(response);
        throw jsonDecode(response.body)['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> deleteGame(int gamerId, String accesstoken) async {
    try {
      var response = await http.delete(Uri.parse("$baseURL/games/$gamerId"),
          headers: headerswithAuth(accesstoken));
      var parsedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return parsedResponse["message"];
      } else {
        tokenExpire(response);
        throw parsedResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<PlaceShotResponse> placeShot(
      int gamerId, String shot, String accesstoken) async {
    try {
      Map<String, String> body = {"shot": shot};
      var response = await http.put(Uri.parse("$baseURL/games/$gamerId"),
          body: jsonEncode(body), headers: headerswithAuth(accesstoken));
      var parsedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return PlaceShotResponse.fromJson(parsedResponse);
      } else {
        tokenExpire(response);
        throw parsedResponse['error'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<GameDetailsResponse> gameDetails(
      int gamerId, String accesstoken) async {
    try {
      var response = await http.get(Uri.parse("$baseURL/games/$gamerId"),
          headers: headerswithAuth(accesstoken));
      if (response.statusCode == 200) {
        return GameDetailsResponse.fromJson(jsonDecode(response.body));
      } else {
        tokenExpire(response);
        throw "${response.statusCode} ${response.reasonPhrase}";
      }
    } catch (e) {
      rethrow;
    }
  }

  tokenExpire(http.Response response) {
    try {
      if (response.reasonPhrase!.toLowerCase() == "unauthorized") {
        throw "We have situation. our session is expired.Please try relogin";
      }
    } catch (e) {
      rethrow;
    }
  }
}
