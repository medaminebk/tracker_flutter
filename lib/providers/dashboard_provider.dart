import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../models/fuel_entry.dart';
import '../models/maintenance.dart';
import '../services/fuel_service.dart';
import '../services/maintenance_service.dart';
import '../services/vehicle_service.dart';
import 'auth_provider.dart';

final fuelServiceProvider = Provider((ref) => FuelService());
final maintenanceServiceProvider = Provider((ref) => MaintenanceService());
final vehicleServiceProvider = Provider((ref) => VehicleService());

final dashboardDataProvider = StreamProvider((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return const Stream.empty();

  final vehicleService = ref.watch(vehicleServiceProvider);
  final fuelService = ref.watch(fuelServiceProvider);
  final maintenanceService = ref.watch(maintenanceServiceProvider);

  return vehicleService.getVehicles(user.uid).switchMap((vehicles) {
    if (vehicles.isEmpty) {
      return Stream.value({'fuel': <FuelEntry>[], 'maintenance': <Maintenance>[]});
    }

    final fuelStreams = vehicles.map((v) => fuelService.getFuelEntries(user.uid, v.id));
    final maintenanceStreams = vehicles.map((v) => maintenanceService.getMaintenance(user.uid, v.id));

    return CombineLatestStream.combine2(
      CombineLatestStream.list(fuelStreams),
      CombineLatestStream.list(maintenanceStreams),
      (List<List<FuelEntry>> fuelLists, List<List<Maintenance>> maintenanceLists) {
        return {
          'fuel': fuelLists.expand((i) => i).toList(),
          'maintenance': maintenanceLists.expand((i) => i).toList(),
        };
      },
    );
  });
});
