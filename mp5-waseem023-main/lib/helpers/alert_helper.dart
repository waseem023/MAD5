import 'package:battleships/main.dart';
import 'package:flutter/material.dart';

class NotificationHelper {
  void showErrorNotification(String message,
      {IconData icon = Icons.remove_circle_outline, bool useImage = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            useImage
                ? Image.asset('images/bang-black.png',
                    color: Colors.white, height: 25)
                : Icon(icon, color: Colors.white),
            const SizedBox(width: 5),
            Text(
              message,
              maxLines: 2,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.red));
  }

  void showSuccessNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        content: Text(
          message,
          maxLines: 2,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green));
  }
}
