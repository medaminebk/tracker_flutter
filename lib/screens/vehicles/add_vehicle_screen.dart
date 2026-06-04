import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/vehicle.dart';
import '../../providers/vehicle_provider.dart';
import '../../providers/auth_provider.dart';

class AddVehicleScreen extends ConsumerStatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  ConsumerState<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends ConsumerState<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController();
  final _licensePlateController = TextEditingController();
  String _selectedFuelType = 'Diesel';

  final List<String> _fuelTypes = ['Diesel', 'Essence', 'Electrique'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vehicle')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Brand'),
                validator: (value) => value!.isEmpty ? 'Please enter brand' : null,
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Model'),
                validator: (value) => value!.isEmpty ? 'Please enter model' : null,
              ),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Please enter year' : null,
              ),
              TextFormField(
                controller: _licensePlateController,
                decoration: const InputDecoration(labelText: 'License Plate'),
                validator: (value) => value!.isEmpty ? 'Please enter license plate' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedFuelType,
                decoration: const InputDecoration(labelText: 'Fuel Type'),
                items: _fuelTypes.map((type) => DropdownMenuItem(value: type, child: Text(type))).toList(),
                onChanged: (value) => setState(() => _selectedFuelType = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Add Vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final user = ref.read(authStateProvider).value;
      if (user == null) return;

      final newVehicle = Vehicle(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        brand: _brandController.text,
        model: _modelController.text,
        year: int.parse(_yearController.text),
        licensePlate: _licensePlateController.text,
        fuelType: _selectedFuelType,
      );

      await ref.read(vehicleServiceProvider).addVehicle(newVehicle);
      if (mounted) Navigator.pop(context);
    }
  }
}
