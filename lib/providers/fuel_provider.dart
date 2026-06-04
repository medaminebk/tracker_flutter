import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/fuel_entry.dart';
import '../services/fuel_service.dart';
import 'auth_provider.dart';
import 'vehicle_provider.dart';

final fuelServiceProvider = Provider((ref) => FuelService());

class FuelEntriesNotifier extends StateNotifier<AsyncValue<List<FuelEntry>>> {
  final Ref ref;
  final FuelService _service;

  FuelEntriesNotifier(this.ref, this._service) : super(const AsyncValue.data([])) {
    _init();
  }

  void _init() {
    ref.listen(authStateProvider, (previous, next) {
      _updateFuelEntries();
    });
    ref.listen(selectedVehicleProvider, (previous, next) {
      _updateFuelEntries();
    });
  }

  void _updateFuelEntries() {
    final user = ref.read(authStateProvider).value;
    final vehicle = ref.read(selectedVehicleProvider);
    if (user != null && vehicle != null) {
      state = const AsyncValue.loading();
      _service.getFuelEntries(user.uid, vehicle.id).listen((entries) {
        state = AsyncValue.data(entries);
      }, onError: (e) {
        state = AsyncValue.error(e, StackTrace.current);
      });
    } else {
      state = const AsyncValue.data([]);
    }
  }
}

final fuelEntriesProvider = StateNotifierProvider<FuelEntriesNotifier, AsyncValue<List<FuelEntry>>>((ref) {
  return FuelEntriesNotifier(ref, ref.watch(fuelServiceProvider));
});
