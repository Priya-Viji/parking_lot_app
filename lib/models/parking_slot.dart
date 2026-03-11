import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSlot {
  final String id;
  final int slotNumber;
  final bool isOccupied;
  final String? reservedBy;
  final DateTime? entryTime;

  ParkingSlot({
    required this.id,
    required this.slotNumber,
    required this.isOccupied,
    this.reservedBy,
    this.entryTime,
  });

  // Convert Firestore map to model
  factory ParkingSlot.fromMap(String id, Map<String, dynamic> data) {
    return ParkingSlot(
      id: id,
      slotNumber: data['slotNumber'] ?? 0,
      isOccupied: data['isOccupied'] ?? false,
      reservedBy: data['reservedBy'],
      entryTime: data['entryTime'] != null
          ? (data['entryTime'] as Timestamp).toDate()
          : null,
    );
  }

  // Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'slotNumber': slotNumber,
      'isOccupied': isOccupied,
      'reservedBy': reservedBy,
      'entryTime': entryTime,
    };
  }
}
