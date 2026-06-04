import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';

class VehicleService {
  final CollectionReference _vehiclesCollection =
      FirebaseFirestore.instance.collection('vehicles');

  Future<void> addVehicle(Vehicle vehicle) async {
    await _vehiclesCollection.doc(vehicle.id).set(vehicle.toJson());
  }

  Stream<List<Vehicle>> getVehicles(String userId) {
    return _vehiclesCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Vehicle.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _vehiclesCollection.doc(vehicle.id).update(vehicle.toJson());
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await _vehiclesCollection.doc(vehicleId).delete();
  }
}
