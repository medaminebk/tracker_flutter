import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/maintenance.dart';
import '../../models/vehicle.dart';
import '../../models/maintenance_category.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/maintenance_category_provider.dart';
import '../../providers/maintenance_provider.dart';

class AddMaintenanceScreen extends ConsumerStatefulWidget {
  const AddMaintenanceScreen({super.key});

  @override
  ConsumerState<AddMaintenanceScreen> createState() => _AddMaintenanceScreenState();
}

class _AddMaintenanceScreenState extends ConsumerState<AddMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  Vehicle? _selectedVehicle;
  DateTime _date = DateTime.now();
  MaintenanceCategory? _selectedCategory;
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final categoriesAsync = ref.watch(maintenanceCategoriesProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance')),
      body: vehiclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (vehicles) {
          if (_selectedVehicle == null && vehicles.isNotEmpty) {
            _selectedVehicle = vehicles.first;
          }

          return categoriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
            data: (categories) {
              if (_selectedCategory == null && categories.isNotEmpty) {
                _selectedCategory = categories.first;
              }

              return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    DropdownButtonFormField<Vehicle>(
                      value: _selectedVehicle,
                      decoration: const InputDecoration(labelText: 'Vehicle'),
                      items: vehicles.map((v) {
                        return DropdownMenuItem(
                          value: v,
                          child: Text('${v.brand} ${v.model}'),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedVehicle = value),
                    ),
                    ListTile(
                      title: Text("Date: ${_date.toLocal().toString().split(' ')[0]}"),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () => _selectDate(context),
                    ),
                    DropdownButtonFormField<MaintenanceCategory>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(labelText: 'Category'),
                      items: categories.map((c) {
                        return DropdownMenuItem(
                          value: c,
                          child: Text(c.name),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedCategory = value),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      validator: (value) => value!.isEmpty ? 'Please enter description' : null,
                    ),
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: 'Amount (MAD)'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Please enter amount' : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && _selectedVehicle != null && _selectedCategory != null) {
                          final userId = authState.value?.uid;
                          if (userId == null) return;

                          final maintenance = Maintenance(
                            id: DateTime.now().microsecondsSinceEpoch.toString(),
                            vehicleId: _selectedVehicle!.id,
                            userId: userId,
                            date: _date,
                            description: _descriptionController.text,
                            amount: double.parse(_amountController.text),
                            categoryId: _selectedCategory!.id,
                          );

                          await ref.read(maintenanceServiceProvider).addMaintenance(maintenance);
                          if (!mounted) return;
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
