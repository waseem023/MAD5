import 'package:battleships/models/game_detail_response.dart';
import 'package:battleships/view_models/game_viewmodel.dart';
import 'package:battleships/view_models/home_viewmodel.dart';
import 'package:battleships/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  final bool isNewGame;
  final String ai;
  final GameDetailsResponse gameDetail;
  const GameScreen(
      {super.key,
      required this.isNewGame,
      required this.ai,
      required this.gameDetail});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    var viewModel = Provider.of<GameViewModel>(context, listen: false);
    if (!widget.isNewGame) {
      viewModel.updateGameDetails(widget.gameDetail);
    } else {
      viewModel.newGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    int rowCount = 6;
    int columnCount = 6;

    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        var viewModel = Provider.of<HomeViewModel>(context, listen: false);
        await viewModel.showCompletedGames();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blue,
          title: Text(
            widget.isNewGame ? "Place Ships" : "Play Game",
            textAlign: TextAlign.center,
          ),
          actions: [
            Consumer<GameViewModel>(builder: (context, viewModel, _) {
              return viewModel.visibleSubmitbtn
                  ? TextButton(
                      onPressed: widget.isNewGame
                          ? () => viewModel.btnSubmitTapped(widget.ai)
                          : () => viewModel.shoot(
                              viewModel.selectedShot, widget.gameDetail),
                      child: Row(
                        children: [
                          widget.isNewGame
                              ? const Icon(Icons.play_arrow_rounded,
                                  color: Colors.white)
                              : Image.asset('images/bang-black.png',
                                  color: Colors.white, height: 25),
                          const SizedBox(width: 3),
                          Text(
                            widget.isNewGame ? "Play" : "Shoot",
                            style: const TextStyle(color: Colors.white),
                          )
                        ],
                      ))
                  : Container();
            })
          ],
        ),
        body: Container(
          decoration: boxDecoration,
          // decoration: const BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage("images/background.png"),
          //         fit: BoxFit.cover)),
          child: Column(
            children: [
              Expanded(
                child: buildGridRows(context, rowCount, columnCount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridRows(BuildContext context, int rowCount, int columnCount) {
    List<String> rowLabels = ['A', 'B', 'C', 'D', 'E'];
    List<int> columnValues = [1, 2, 3, 4, 5];

    double itemSize = MediaQuery.of(context).size.width / columnCount;
    double itemHeigth = MediaQuery.of(context).size.height / columnCount;

    List<Widget> rows = List.generate(rowCount, (rowIndex) {
      List<Widget> columns = List.generate(columnCount, (colIndex) {
        if (rowIndex == 0 && colIndex == 0) {
          // Display the top-left cell with an empty container
          return SizedBox(
            width: itemSize,
            height: itemHeigth,
          );
        } else if (rowIndex == 0) {
          // Display the first row with values 1-5
          return Container(
            width: itemSize,
            height: itemHeigth,
            decoration: BoxDecoration(
                border: Border.all()), // Change the color as needed
            child: Center(
              child: Text(
                '${columnValues[colIndex - 1]}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else if (colIndex == 0) {
          // Display the first column with values A-E
          return Container(
            width: itemSize,
            height: itemHeigth,
            decoration: BoxDecoration(
                border: Border.all()), // Change the color as needed
            child: Center(
              child: Text(
                rowLabels[rowIndex - 1],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        } else {
          // Display the remaining cells with the combination of column and row values
          return Consumer<GameViewModel>(builder: (context, viewModel, _) {
            var spots =
                '${rowLabels[rowIndex - 1]}${columnValues[colIndex - 1]}';
            return Material(
              shape: Border.all(),
              color: Colors.transparent,
              child: Container(
                width: itemSize,
                height: itemHeigth,
                alignment: Alignment.center,
                // Change the color as needed
                child: Stack(
                  children: [
                    if (viewModel.selectedShot == spots)
                      Container(
                        width: itemSize,
                        height: itemHeigth,
                        color: const Color.fromARGB(127, 244, 67, 54),
                      ),
                    if (viewModel.shipSpots.contains(spots))
                      Center(
                        child: Image.asset("images/player1.png"),
                      ),
                    if (viewModel.shipSunk.contains(spots)) ...[
                      Center(child: Image.asset("images/wrek.png")),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Center(
                          child: Image.asset("images/bang.png"),
                        ),
                      )
                    ],
                    if (viewModel.shipWrek.contains(spots))
                      Center(
                        child: Image.asset("images/wrek.png"),
                      ),
                    if (viewModel.shots.contains(spots) &&
                        !viewModel.shipSunk.contains(spots))
                      Center(child: Image.asset("images/Explosive.png")),
                    if (viewModel.visibleSubmitbtn)
                      InkWell(onTap: () {
                        // Handle click for other cells
                        widget.isNewGame
                            ? viewModel.placeShips(spots)
                            : viewModel.chooseShot(spots);
                        print('Clicked on $spots');
                      }),
                  ],
                ),
              ),
            );
          });
        }
      });

      return Flexible(
        child: Row(
          children: columns,
        ),
      );
    });

    return Column(
      children: rows,
    );
  }
}
