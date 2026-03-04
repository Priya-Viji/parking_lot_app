import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingSlot {
  final String id; //Firebase document ID
  final int slotNumber; // Unique slot number
  final bool isAvailable; // Availability status
  final String? reservedBy; //User Id if reserved
  final DateTime? entryTime;

  ParkingSlot({
    required this.id,
    required this.slotNumber,
    required this.isAvailable,
    this.reservedBy,
    this.entryTime,
  });
  // Convert Firestore document to model
  factory ParkingSlot.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParkingSlot(
      id: doc.id,
      slotNumber: data['slotNumber'],
      isAvailable: data['isAvailable'],
      reservedBy: data['reservedBy'],
      entryTime: data['entryTime'] != null
          ? (data['entryTime'] as Timestamp).toDate()
          : null,
    );
  }

  //Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'slotNumber': slotNumber,
      'isAvailable': isAvailable,
      'reservedBy': reservedBy,
      'entryTime': entryTime,
    };
  }
}
