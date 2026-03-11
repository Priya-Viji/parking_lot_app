import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/parking_provider.dart';
import '../models/parking_history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final parkingProvider = Provider.of<ParkingProvider>(context);
    final userId = authProvider.user!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Parking History",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<List<ParkingHistory>>(
        stream: parkingProvider.getUserHistory(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final history  = snapshot.data!;

          if (history.isEmpty) {
            return const Center(child: Text("No Parking history Available.",style: TextStyle(fontSize: 16)));
          }

         return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];

              final entry = DateFormat(
                'dd MMM, hh:mm a',
              ).format(item.entryTime);
              final exit = DateFormat('dd MMM, hh:mm a').format(item.exitTime);
              final duration = item.exitTime
                  .difference(item.entryTime)
                  .inMinutes;

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text("Slot : ${item.slotNumber}",style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Entry : $entry"),
                      Text("Exit : $exit"),
                      Text("Duration : $duration minutes"),
                    ],
                  ),
                  trailing: Text(
                    "₹${item.fee}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
