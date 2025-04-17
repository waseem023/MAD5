import 'package:battleships/main.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static int loaderCount = 0;
  Future<String?> pickAIType() async => await showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Lets play againt?"),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                // separatorBuilder: (context, index) => const Divider(),
                // itemCount: options.length,
                children: [
                  ListTile(
                    title: const Text("Random"),
                    onTap: () => Navigator.pop(context, "Random"),
                  ),
                  ListTile(
                    title: const Text("Perfect"),
                    onTap: () => Navigator.pop(context, "Perfect"),
                  ),
                  ListTile(
                    title: const Text("One Ship (A1)"),
                    onTap: () => Navigator.pop(context, "OneShip"),
                  )
                ]),
          ));

  Future<void> winnerPopUp(bool weWon) async => await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Winner!!!"),
          content: weWon
              ? const Text(
                  "You Won!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green, fontSize: 18),
                )
              : const Text(
                  "You Loose!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
        ),
      );

  Future<void> loader() async => await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                  dimension: 25,
                  child: CircularProgressIndicator.adaptive(strokeWidth: 3)),
              SizedBox(width: 10),
              Flexible(
                  child: Text("Please wait...", style: TextStyle(fontSize: 16)))
            ],
          ),
        ),
      );
}
