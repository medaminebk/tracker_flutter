import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/dashboard_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../models/fuel_entry.dart';
import '../../models/maintenance.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(dashboardDataProvider);
    final vehiclesAsync = ref.watch(vehiclesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final fuelEntries = data['fuel'] as List<FuelEntry>;
          final maintenanceEntries = data['maintenance'] as List<Maintenance>;
          final vehicles = vehiclesAsync.value ?? [];

          final now = DateTime.now();
          final startOfMonth = DateTime(now.year, now.month, 1);

          double fuelExpenses = 0;
          for (var entry in fuelEntries) {
            if (entry.date.isAfter(startOfMonth)) {
              fuelExpenses += entry.amount;
            }
          }

          double maintenanceExpenses = 0;
          for (var entry in maintenanceEntries) {
            if (entry.date.isAfter(startOfMonth)) {
              maintenanceExpenses += entry.amount;
            }
          }

          double totalExpenses = fuelExpenses + maintenanceExpenses;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text('Monthly Expenses: \$${totalExpenses.toStringAsFixed(2)}', style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Fuel (70%): \$${(totalExpenses * 0.7).toStringAsFixed(2)}'),
                            Text('Maintenance (30%): \$${(totalExpenses * 0.3).toStringAsFixed(2)}'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Monthly Fuel Consumption', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                SizedBox(
                  height: 300,
                  child: LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: fuelEntries
                              .where((e) => e.date.isAfter(startOfMonth))
                              .map((e) => FlSpot(e.date.day.toDouble(), e.liters))
                              .toList(),
                          isCurved: true,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text('Vehicles Monthly Costs', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    final fuelCost = fuelEntries
                        .where((e) => e.vehicleId == vehicle.id && e.date.isAfter(startOfMonth))
                        .fold(0.0, (sum, e) => sum + e.amount);
                    final maintenanceCost = maintenanceEntries
                        .where((e) => e.vehicleId == vehicle.id && e.date.isAfter(startOfMonth))
                        .fold(0.0, (sum, e) => sum + e.amount);
                    
                    return ListTile(
                      title: Text('${vehicle.brand} ${vehicle.model}'),
                      trailing: Text('\$${(fuelCost + maintenanceCost).toStringAsFixed(2)}'),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
