import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/maintenance_category.dart';

class MaintenanceCategoryService {
  final CollectionReference _categoryCollection =
      FirebaseFirestore.instance.collection('maintenance_categories');

  Stream<List<MaintenanceCategory>> getCategories() {
    return _categoryCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => MaintenanceCategory.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
