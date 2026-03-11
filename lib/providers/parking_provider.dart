import 'package:flutter/material.dart';
import '../models/parking_slot.dart';
import '../models/parking_history.dart';
import '../services/parking_service.dart';

class ParkingProvider extends ChangeNotifier {
  final ParkingService _service = ParkingService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Real-time stream of all parking slots
  Stream<List<ParkingSlot>> get slotsStream => _service.getSlots();

  /// Reserve a parking slot
  Future<void> reserveSlot({
    required String slotId,
    required String userId,
  }) async {
    _setLoading(true);
    try {
      await _service.reserveSlot(slotId, userId);
    } finally {
      _setLoading(false);
    }
  }

  /// Release a slot and return calculated fee
  Future<int> releaseSlot({
    required String slotId,
    required DateTime entryTime,
    required String userId,
    required int slotNumber,
  }) async {
    _setLoading(true);
    try {
      return await _service.releaseSlot(
        slotId: slotId,
        entryTime: entryTime,
        userId: userId,
        slotNumber: slotNumber,
      );
    } finally {
      _setLoading(false);
    }
  }

  /// Real-time stream of user's parking history
  Stream<List<ParkingHistory>> getUserHistory(String userId) {
    return _service.getUserHistory(userId);
  }

  /// Count available slots
  Future<int> getAvailableSlots() => _service.countAvailableSlots();

  /// Count active reservations for a user
  Future<int> getActiveReservationCount(String userId) =>
      _service.countUserReservations(userId);

      int calculateFee(DateTime entry, DateTime exit) {
    final totalMinutes = exit.difference(entry).inMinutes;

    if (totalMinutes <= 10) return 0;

    final minutesAfterFree = totalMinutes - 10;
    final hours = (minutesAfterFree / 60).ceil();

    return hours * 100;
  }

}
