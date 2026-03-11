import 'package:flutter/material.dart';

class ReserveDialog {
  static void show(
    BuildContext context,
    int slotNumber,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Reserve Slot"),
          content: Text("Do you want to reserve Slot $slotNumber?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
              child: Text("Reserve"),
            ),
          ],
        );
      },
    );
  }
}
