import 'package:flutter/material.dart';

class ReleaseDialog {
  static void show(
    BuildContext context,
    int slotNumber,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Release Slot"),
          content: Text("Are you sure you want to release Slot $slotNumber?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: const Text("Release"),
            ),
          ],
        );
      },
    );
  }
}
