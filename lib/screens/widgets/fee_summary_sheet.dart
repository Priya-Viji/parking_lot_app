import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeeSummarySheet {
  static void show(
    BuildContext context, {
    required int slotNumber,
    required DateTime entryTime,
    required DateTime exitTime,
    required int fee,
    required VoidCallback onConfirm,
  }) {
    final duration = exitTime.difference(entryTime);
    final formattedEntry = DateFormat('hh:mm a').format(entryTime);
    final formattedExit = DateFormat('hh:mm a').format(exitTime);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  "Parking Fee Summary",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Text("Slot Number: $slotNumber",
                  style: const TextStyle(fontSize: 16)),

              Text("Entry Time: $formattedEntry",
                  style: const TextStyle(fontSize: 16)),

              Text("Exit Time: $formattedExit",
                  style: const TextStyle(fontSize: 16)),

              Text("Duration: ${duration.inMinutes} minutes",
                  style: const TextStyle(fontSize: 16)),

              const SizedBox(height: 10),

              Text(
                "Total Fee: ₹$fee",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

