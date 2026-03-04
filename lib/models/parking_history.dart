import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingHistory {
  final String id; // Firestore document ID
  final String userId; // UID of the user
  final int slotNumber; // Slot reserved
  final DateTime entryTime;
  final DateTime exitTime;
  final int fee; // Parking fee

  ParkingHistory({
    required this.id,
    required this.userId,
    required this.slotNumber,
    required this.entryTime,
    required this.exitTime,
    required this.fee,
  });

  // Convert Firestore document to model
  factory ParkingHistory.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ParkingHistory(
      id: doc.id,
      userId: data['userId'],
      slotNumber: data['slotNumber'],
      entryTime: (data['entryTime'] as Timestamp).toDate(),
      exitTime: (data['exitTime'] as Timestamp).toDate(),
      fee: data['fee'],
    );
  }

  // Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'slotNumber': slotNumber,
      'entryTime': entryTime,
      'exitTime': exitTime,
      'fee': fee,
    };
  }
}
