import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/maintenance.dart';

class MaintenanceService {
  final CollectionReference _maintenanceCollection =
      FirebaseFirestore.instance.collection('maintenance');

  Future<void> addMaintenance(Maintenance maintenance) async {
    await _maintenanceCollection.doc(maintenance.id).set(maintenance.toJson());
  }

  Stream<List<Maintenance>> getMaintenance(String userId, String vehicleId) {
    return _maintenanceCollection
        .where('userId', isEqualTo: userId)
        .where('vehicleId', isEqualTo: vehicleId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Maintenance.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateMaintenance(Maintenance maintenance) async {
    await _maintenanceCollection.doc(maintenance.id).update(maintenance.toJson());
  }

  Future<void> deleteMaintenance(String maintenanceId) async {
    await _maintenanceCollection.doc(maintenanceId).delete();
  }
}
