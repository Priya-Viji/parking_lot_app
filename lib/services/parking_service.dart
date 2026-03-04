import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_slot.dart';

class ParkingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> initializeSlots(int totalSlots) async {
    for (int i = 1; i <= totalSlots; i++) {
      await _db.collection('parking_slots').doc('slot_$i').set({
        'slotNumber': i,
        'isAvailable': true,
        'reservedBy': null,
        'entryTime': null,
      });
    }
    print("Initialized $totalSlots slots in Firestore");
  }

  // Get all parking slots as a stream

  Stream<List<ParkingSlot>> getSlots() {
    return _db
        .collection('parking_slots')
        .orderBy('slotNumber')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ParkingSlot.fromDoc(doc)).toList(),
        );
  }

  // Reserve a parking slot
  Future<void> reserveSlot(String slotId, String userId) async {
    await _db.collection('parking_slots').doc(slotId).update({
      "isAvailable": false,
      "reservedBy": userId,
      "entryTime": Timestamp.fromDate(DateTime.now()), // ✅ FIXED
    });
  }

  // Release a parking slot and calculate fee
  
  Future<int> releaseSlot({
    required String slotId,
    required DateTime entryTime,
    required String userId,
    required int slotNumber,
  }) async {
    final DateTime exitTime = DateTime.now();
    final Duration duration = exitTime.difference(entryTime);

    // Calculate fee
    int fee = 0;
    if (duration.inMinutes > 10) {
      int hours = duration.inHours;
      if (duration.inMinutes % 60 != 0) hours += 1; // round up
      fee = hours * 100;
    }

    // Save history
    try {
      await _db.collection('parking_history').add({
        "slotId": slotId,
        "slotNumber": slotNumber,
        "userId": userId,
        "entryTime": Timestamp.fromDate(entryTime), // ✅ ensure Timestamp
        "exitTime": Timestamp.fromDate(exitTime),
        "fee": fee,
      });
      print("History saved for slot $slotNumber");
    } catch (e) {
      print("Error saving history: $e");
    }

    // Release the slot
    await _db.collection('parking_slots').doc(slotId).update({
      "isAvailable": true,
      "reservedBy": null,
      "entryTime": null,
    });

    return fee;
  }

  // Stream of user-specific parking history
  Stream<QuerySnapshot> getUserHistory(String userId) {
    return _db
        .collection('parking_history')
        .where('userId', isEqualTo: userId)
        .where('entryTime', isNotEqualTo: null)
        .orderBy('entryTime', descending: true)
        .snapshots();
  }

  // ----------------------------
  // Count available slots
  // ----------------------------
  Future<int> countAvailableSlots() async {
    final snapshot = await _db
        .collection('parking_slots')
        .where('isAvailable', isEqualTo: true)
        .get();
    return snapshot.docs.length;
  }

  // Count active reservations for a user
  
  Future<int> countUserReservations(String userId) async {
    final snapshot = await _db
        .collection('parking_slots')
        .where('reservedBy', isEqualTo: userId)
        .get();
    return snapshot.docs.length;
  }
}
