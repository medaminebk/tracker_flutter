import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vehicle.dart';
import '../services/vehicle_service.dart';
import 'auth_provider.dart';

final vehicleServiceProvider = Provider((ref) => VehicleService());

class VehiclesNotifier extends StateNotifier<AsyncValue<List<Vehicle>>> {
  final Ref ref;
  final VehicleService _service;

  VehiclesNotifier(this.ref, this._service) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    final user = ref.read(authStateProvider).value;
    if (user != null) {
      _loadVehicles(user.uid);
    }
  }

  void _loadVehicles(String userId) {
    _service.getVehicles(userId).listen((vehicles) {
      state = AsyncValue.data(vehicles);
    }, onError: (e) {
      state = AsyncValue.error(e, StackTrace.current);
    });
  }
}

final vehiclesProvider = StateNotifierProvider<VehiclesNotifier, AsyncValue<List<Vehicle>>>((ref) {
  return VehiclesNotifier(ref, ref.watch(vehicleServiceProvider));
});

final selectedVehicleProvider = StateProvider<Vehicle?>((ref) => null);
