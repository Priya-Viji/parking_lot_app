import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/parking_slot.dart';
import '../services/parking_service.dart';

class ParkingProvider extends ChangeNotifier {
  final ParkingService _service = ParkingService();

  // ----------------------------
  // Configurable total slots
  // ----------------------------
  final int totalSlots = 20;

  // ----------------------------
  // Stream of all parking slots
  // ----------------------------
  Stream<List<ParkingSlot>> get slotsStream => _service.getSlots();

  // ----------------------------
  // Loading state
  // ----------------------------
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ----------------------------
  // Reserve a slot
  // ----------------------------
  Future<void> reserveSlot({
    required String slotId,
    required String userId,
  }) async {
    _setLoading(true);
    try {
      // ✅ Service now saves entryTime as Timestamp
      await _service.reserveSlot(slotId, userId);
    } finally {
      _setLoading(false);
    }
  }

  // ----------------------------
  // Release a slot and calculate fee
  // ----------------------------
  Future<int> releaseSlot({
    required String slotId,
    required DateTime entryTime,
    required String userId,
    required int slotNumber,
  }) async {
    _setLoading(true);
    try {
      // ✅ Service handles fee + exitTime + history saving
      final fee = await _service.releaseSlot(
        slotId: slotId,
        entryTime: entryTime,
        userId: userId,
        slotNumber: slotNumber,
      );
      return fee;
    } finally {
      _setLoading(false);
    }
  }

  // ----------------------------
  // User history stream
  // ----------------------------
  Stream<QuerySnapshot> getUserHistory(String userId) {
    return _service.getUserHistory(userId);
  }

  // ----------------------------
  // Summary helpers
  // ----------------------------
  Future<int> getAvailableSlots() async {
    return await _service.countAvailableSlots();
  }

  Future<int> getActiveReservationCount(String userId) async {
    return await _service.countUserReservations(userId);
  }
}
