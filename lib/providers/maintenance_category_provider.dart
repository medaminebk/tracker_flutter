import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/maintenance_category.dart';
import '../services/maintenance_category_service.dart';

final maintenanceCategoryServiceProvider = Provider((ref) => MaintenanceCategoryService());

final maintenanceCategoriesProvider = StreamProvider<List<MaintenanceCategory>>((ref) {
  return ref.watch(maintenanceCategoryServiceProvider).getCategories();
});
