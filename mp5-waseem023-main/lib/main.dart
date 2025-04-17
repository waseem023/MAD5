import 'package:battleships/view_models/game_viewmodel.dart';
import 'package:battleships/view_models/home_viewmodel.dart';
import 'package:battleships/view_models/login_viewmodel.dart';
import 'package:battleships/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
BuildContext get context => navigatorKey.currentContext!;
void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => LoginViewModel()),
      ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ChangeNotifierProvider(create: (context) => GameViewModel()),
    ],
    child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Battleships',
        navigatorKey: navigatorKey,
        home: const SplashScreen()),
  ));
}
