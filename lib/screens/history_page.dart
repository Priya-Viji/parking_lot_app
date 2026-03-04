import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/parking_provider.dart';

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
      body: StreamBuilder<QuerySnapshot>(
        stream: parkingProvider.getUserHistory(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No parking history found."));
          }

          final historyDocs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {
              final doc = historyDocs[index];
              final data = doc.data() as Map<String, dynamic>;

              final slotNumber = data['slotNumber'] ?? 0;

              // ✅ Safely handle timestamps
              DateTime? entryTime;
              DateTime? exitTime;

              if (data['entryTime'] is Timestamp) {
                entryTime = (data['entryTime'] as Timestamp).toDate();
              }
              if (data['exitTime'] is Timestamp) {
                exitTime = (data['exitTime'] as Timestamp).toDate();
              }

              final fee = data['fee'] ?? 0;

              final formattedEntry = entryTime != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(entryTime)
                  : "N/A";
              final formattedExit = exitTime != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(exitTime)
                  : "N/A";

              return Card(
                elevation: 6,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      "$slotNumber",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text("Slot $slotNumber"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Entry: $formattedEntry"),
                      Text("Exit: $formattedExit"),
                      Text("Fee: \$$fee"),
                    ],
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
