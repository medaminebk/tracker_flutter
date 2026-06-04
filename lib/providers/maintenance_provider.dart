import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/maintenance.dart';
import '../services/maintenance_service.dart';
import 'auth_provider.dart';
import 'vehicle_provider.dart';

final maintenanceServiceProvider = Provider((ref) => MaintenanceService());

class MaintenanceNotifier extends StateNotifier<AsyncValue<List<Maintenance>>> {
  final Ref ref;
  final MaintenanceService _service;

  MaintenanceNotifier(this.ref, this._service) : super(const AsyncValue.data([])) {
    _init();
  }

  void _init() {
    ref.listen(authStateProvider, (previous, next) {
      _updateMaintenance();
    });
    ref.listen(selectedVehicleProvider, (previous, next) {
      _updateMaintenance();
    });
  }

  void _updateMaintenance() {
    final user = ref.read(authStateProvider).value;
    final vehicle = ref.read(selectedVehicleProvider);
    if (user != null && vehicle != null) {
      state = const AsyncValue.loading();
      _service.getMaintenance(user.uid, vehicle.id).listen((maintenanceList) {
        state = AsyncValue.data(maintenanceList);
      }, onError: (e) {
        state = AsyncValue.error(e, StackTrace.current);
      });
    } else {
      state = const AsyncValue.data([]);
    }
  }
}

final maintenanceProvider = StateNotifierProvider<MaintenanceNotifier, AsyncValue<List<Maintenance>>>((ref) {
  return MaintenanceNotifier(ref, ref.watch(maintenanceServiceProvider));
});
