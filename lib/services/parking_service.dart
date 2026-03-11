import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_slot.dart';
import '../models/parking_history.dart';

class ParkingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  static const String slotsCollection = "parking_slots";

  /// Watch all parking slots in real-time
  Stream<List<ParkingSlot>> getSlots() {
    return _db.collection(slotsCollection).orderBy('slotNumber').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ParkingSlot.fromMap(doc.id, doc.data()))
          .toList();
    });
  }

  /// Reserve a slot using Firestore transaction
  Future<void> reserveSlot(String slotId, String userId) async {
    final docRef = _db.collection(slotsCollection).doc(slotId);

    await _db.runTransaction((tx) async {
      final snap = await tx.get(docRef);

      if (!snap.exists) throw Exception("Slot not found");

      final isOccupied = (snap['isOccupied'] ?? false) as bool;

      if (isOccupied) {
        throw Exception("Slot already occupied");
      }

      tx.update(docRef, {
        'isOccupied': true,
        'reservedBy': userId,
        'entryTime': FieldValue.serverTimestamp(),
      });
    });
  }

  /// Release slot, calculate fee, and save history
  Future<int> releaseSlot({
    required String slotId,
    required DateTime entryTime,
    required String userId,
    required int slotNumber,
  }) async {
    final exitTime = DateTime.now();
    final fee = _calculateFee(entryTime, exitTime);

    final batch = _db.batch();

    // Update slot
    final slotRef = _db.collection(slotsCollection).doc(slotId);
    batch.update(slotRef, {
      'isOccupied': false,
      'reservedBy': null,
      'entryTime': null,
    });

    // Save history
    final historyRef = _db
        .collection('users')
        .doc(userId)
        .collection('history')
        .doc();

    final history = ParkingHistory(
      slotNumber: slotNumber,
      entryTime: entryTime,
      exitTime: exitTime,
      fee: fee,
    );

    batch.set(historyRef, history.toMap());

    await batch.commit();
    return fee;
  }

  /// Fee calculation logic
  int _calculateFee(DateTime entry, DateTime exit) {
    final totalMinutes = exit.difference(entry).inMinutes;

    if (totalMinutes <= 10) return 0;

    final minutesAfterFree = totalMinutes - 10;
    final hours = (minutesAfterFree / 60).ceil();

    return hours * 100;
  }

  /// Watch user's parking history in real-time
  Stream<List<ParkingHistory>> getUserHistory(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('history')
        .orderBy('entryTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ParkingHistory.fromMap(doc.data()))
              .toList();
        });
  }

  // ---------------------------------------------------------
  // Count available slots
  // ---------------------------------------------------------
  Future<int> countAvailableSlots() async {
    final snapshot = await _db
        .collection('parking_slots')
        .where('isOccupied', isEqualTo: false)
        .get();

    return snapshot.docs.length;
  }

  // ---------------------------------------------------------
  // Count active reservations for a user
  // ---------------------------------------------------------
  Future<int> countUserReservations(String userId) async {
    final snapshot = await _db
        .collection('parking_slots')
        .where('reservedBy', isEqualTo: userId)
        .where('isOccupied', isEqualTo: true)
        .get();

    return snapshot.docs.length;
  }


}
