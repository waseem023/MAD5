import 'package:battleships/utils/global_values.dart';
import 'package:battleships/view_models/home_viewmodel.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    var homeviewModel = Provider.of<HomeViewModel>(context, listen: false);
    homeviewModel.showHistory = false;
    Future.delayed(Duration.zero, homeviewModel.showCompletedGames);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(builder: (context, viewModel, _) {
      return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                decoration: boxDecoration,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5),
                        child: Text(
                          "Battleships".toUpperCase(),
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        "Login as ${GlobalValues.username}",
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    onTap: viewModel.showAtive,
                    leading: const Icon(
                      Icons.featured_play_list_rounded,
                    ),
                    title: const Text("Show Active Games"),
                  ),
                  ListTile(
                    onTap: viewModel.newGame,
                    leading: const Icon(
                      Icons.add_rounded,
                    ),
                    title: const Text("New Game"),
                  ),
                  ListTile(
                    onTap: () => viewModel.newGamewithAI(mounted),
                    leading: const FaIcon(FontAwesomeIcons.robot),
                    title: const Text("New Game (AI)"),
                  ),
                  ListTile(
                    onTap: viewModel.displayHistory,
                    leading: const Icon(
                      Icons.list,
                    ),
                    title: const Text("Show Completed Games"),
                  ),
                  ListTile(
                    onTap: viewModel.logout,
                    leading: const Icon(
                      Icons.logout_rounded,
                    ),
                    title: const Text("Logout"),
                  ),
                ],
              ))
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          title: const Text(
            "Battleship",
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
                onPressed: viewModel.showCompletedGames,
                icon: const Icon(Icons.replay_rounded))
          ],
        ),
        body: viewModel.games.isEmpty
            ? Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: Text(
                            viewModel.showHistory
                                ? "No Finished Games"
                                : "No Active Games",
                            style: const TextStyle(fontSize: 20))),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: viewModel.games.length,
                itemBuilder: (context, index) {
                  var game = viewModel.games[index];
                  var data = game.turn != 0
                      ? game.turn == game.position
                          ? "MyTurn"
                          : "OponentsTurn"
                      : game.status == game.position
                          ? "You Won"
                          : game.status == 0
                              ? "Matchmaking"
                              : "You Loose";
                  var listTile = ListTile(
                    onTap: () => viewModel.showGameStatus(index),
                    leading: Text(
                      "#${game.id}",
                    ),
                    title: Text(
                        "${game.player1} ${game.player2.isNotEmpty ? (" vs ${game.player2}") : ""}",
                        style: const TextStyle(fontSize: 18)),
                    trailing: Text(data),
                  );
                  return viewModel.showHistory
                      ? listTile
                      : Dismissible(
                          key: ValueKey(game.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 12.0),
                                  child: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (direction) =>
                              viewModel.deleteGame(direction, game.id),
                          child: listTile,
                        );
                }),
      );
    });
  }
}
