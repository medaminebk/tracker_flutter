import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/fuel_entry.dart';
import '../../providers/auth_provider.dart';
import '../../providers/fuel_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../models/vehicle.dart';

class AddFuelScreen extends ConsumerStatefulWidget {
  const AddFuelScreen({super.key});

  @override
  ConsumerState<AddFuelScreen> createState() => _AddFuelScreenState();
}

class _AddFuelScreenState extends ConsumerState<AddFuelScreen> {
  final _formKey = GlobalKey<FormState>();
  Vehicle? _selectedVehicle;
  DateTime _date = DateTime.now();
  final _litersController = TextEditingController();
  final _amountController = TextEditingController();
  final _mileageController = TextEditingController();

  @override
  void dispose() {
    _litersController.dispose();
    _amountController.dispose();
    _mileageController.dispose();
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
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Fuel Entry')),
      body: vehiclesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (vehicles) {
          if (_selectedVehicle == null && vehicles.isNotEmpty) {
            _selectedVehicle = vehicles.first;
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
                      child: Text(v.make + ' ' + v.model),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedVehicle = value),
                ),
                ListTile(
                  title: Text("Date: ${_date.toLocal().toString().split(' ')[0]}"),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
                TextFormField(
                  controller: _litersController,
                  decoration: const InputDecoration(labelText: 'Liters'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter liters' : null,
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount (MAD)'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter amount' : null,
                ),
                TextFormField(
                  controller: _mileageController,
                  decoration: const InputDecoration(labelText: 'Mileage'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Please enter mileage' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && _selectedVehicle != null) {
                      final userId = authState.value?.uid;
                      if (userId == null) return;

                      final fuelEntry = FuelEntry(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        vehicleId: _selectedVehicle!.id,
                        userId: userId,
                        date: _date,
                        liters: double.parse(_litersController.text),
                        amount: double.parse(_amountController.text),
                        mileage: int.parse(_mileageController.text),
                      );

                      await ref.read(fuelServiceProvider).addFuelEntry(fuelEntry);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
