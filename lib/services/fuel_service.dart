import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/fuel_entry.dart';

class FuelService {
  final CollectionReference _fuelEntriesCollection =
      FirebaseFirestore.instance.collection('fuelEntries');

  Future<void> addFuelEntry(FuelEntry fuelEntry) async {
    await _fuelEntriesCollection.doc(fuelEntry.id).set(fuelEntry.toJson());
  }

  Stream<List<FuelEntry>> getFuelEntries(String userId, String vehicleId) {
    return _fuelEntriesCollection
        .where('userId', isEqualTo: userId)
        .where('vehicleId', isEqualTo: vehicleId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FuelEntry.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateFuelEntry(FuelEntry fuelEntry) async {
    await _fuelEntriesCollection.doc(fuelEntry.id).update(fuelEntry.toJson());
  }

  Future<void> deleteFuelEntry(String fuelEntryId) async {
    await _fuelEntriesCollection.doc(fuelEntryId).delete();
  }
}
