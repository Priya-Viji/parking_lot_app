import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingHistory {
  final int slotNumber;
  final DateTime entryTime;
  final DateTime exitTime;
  final int fee;

  ParkingHistory({
    required this.slotNumber,
    required this.entryTime,
    required this.exitTime,
    required this.fee,
  });

  // Convert Firestore map to model
  factory ParkingHistory.fromMap(Map<String, dynamic> data) {
    return ParkingHistory(
      slotNumber: data['slotNumber'] ?? 0,
      entryTime: (data['entryTime'] as Timestamp).toDate(),
      exitTime: (data['exitTime'] as Timestamp).toDate(),
      fee: data['fee'] ?? 0,
    );
  }

  // Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'slotNumber': slotNumber,
      'entryTime': entryTime,
      'exitTime': exitTime,
      'fee': fee,
    };
  }
}
