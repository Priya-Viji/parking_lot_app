import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationSummary {
  static void show(
    BuildContext context, {
    required int slotNumber,
    required DateTime entryTime,
  }) {
    final formattedEntry = DateFormat('hh:mm a').format(entryTime);

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
              // Top drag handle
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

              // Title
              const Center(
                child: Text(
                  "Reservation Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),

              // Slot number
              Text(
                "Slot Number: $slotNumber",
                style: const TextStyle(fontSize: 16),
              ),

              // Entry time
              Text(
                "Entry Time: $formattedEntry",
                style: const TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 20),

              // OK button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
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
