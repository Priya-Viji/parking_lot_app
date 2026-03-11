import 'package:flutter/material.dart';
import 'package:parking_lot_app/screens/widgets/fee_summary_sheet.dart';
import 'package:parking_lot_app/screens/widgets/release_dialog.dart';
import 'package:parking_lot_app/screens/widgets/reservation_summary.dart';
import 'package:parking_lot_app/screens/widgets/reserve_dialog.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Parking Lot",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<List<ParkingSlot>>(
        stream: parkingProvider.slotsStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final slots = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: slots.length,
              itemBuilder: (context, index) {
                final slot = slots[index];

                final isOccupied = slot.isOccupied;
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
                        ReserveDialog.show(context, slot.slotNumber, () async {
                          await parkingProvider.reserveSlot(
                            slotId: slot.id,
                            userId: userId,
                          );

                          if (!context.mounted) return;

                          final entryTime = DateTime.now();

                          ReservationSummary.show(
                            context,
                            slotNumber: slot.slotNumber,
                            entryTime: entryTime,
                          );

                        });
                      } else if (isMine && slot.entryTime != null) {
                        ReleaseDialog.show(context, slot.slotNumber, () async {
                          final exitTime = DateTime.now();
                          final fee = parkingProvider.calculateFee(
                            slot.entryTime!,
                            exitTime,
                          );

                          FeeSummarySheet.show(
                            context,
                            slotNumber: slot.slotNumber,
                            entryTime: slot.entryTime!,
                            exitTime: exitTime,
                            fee: fee,
                            onConfirm: () async {
                              final finalFee = await parkingProvider
                                  .releaseSlot(
                                    slotId: slot.id,
                                    entryTime: slot.entryTime!,
                                    userId: userId,
                                    slotNumber: slot.slotNumber,
                                  );

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Slot ${slot.slotNumber} released. Fee: ₹$finalFee",
                                  ),
                                ),
                              );
                            },
                          );
                        });
                      } else {
                        // Someone else's slot
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.redAccent,
                            content: Text(
                              "Slot ${slot.slotNumber} is occupied by another user.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  },
                  child: Container(
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
                            Text(
                              isMine ? "Your Reservation" : "Occupied",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
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
