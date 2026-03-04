import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/parking_provider.dart';
import '../models/parking_slot.dart';

class SlotsPage extends StatelessWidget {
  const SlotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final parkingProvider = Provider.of<ParkingProvider>(context);
    final userId = authProvider.user!.uid;

    // Configurable total slots
    final int totalSlots = 20;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parking Lot",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.deepPurple,
       leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),

      ),
      body: StreamBuilder<List<ParkingSlot>>(
        stream: parkingProvider.slotsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final slots = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:3 , // 3 columns
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: totalSlots, // always show N slots
              itemBuilder: (context, index) {
                // If backend has fewer slots, fill with placeholder
                final slot = index < slots.length ? slots[index] : null;

                if (slot == null) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Slot ${index + 1}\nAvailable",
                        style: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final isOccupied = !slot.isAvailable;
                final isMine = slot.reservedBy == userId;

                Color slotColor;
                if (!isOccupied) {
                  slotColor = Colors.green;
                } else if (isMine) {
                  slotColor = Colors.orange;
                } else {
                  slotColor = Colors.red;
                }

                return GestureDetector(
                  onTap: () async {
                    if (parkingProvider.isLoading) return;

                    try {
                      if (!isOccupied) {
                        // Reserve slot
                        await parkingProvider.reserveSlot(
                          slotId: slot.id,
                          userId: userId,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Reserved slot ${slot.slotNumber}"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      } else if (isMine && slot.entryTime != null) {
                        // Release slot
                        final fee = await parkingProvider.releaseSlot(
                          slotId: slot.id,
                          entryTime: slot.entryTime!,
                          userId: userId,
                          slotNumber: slot.slotNumber,
                        );

                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Released slot ${slot.slotNumber}. Fee: \$$fee",
                            ),
                          ),
                        );
                      } else {
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Slot ${slot.slotNumber} is occupied by another user.",
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")),
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: slotColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Slot ${slot.slotNumber}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (isOccupied)
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    isMine ? "Your Reservation" : "Occupied",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (parkingProvider.isLoading)
                        const Positioned.fill(
                          child: Opacity(
                            opacity: 0.5,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
