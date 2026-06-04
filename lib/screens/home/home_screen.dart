import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Vehicles'),
          BottomNavigationBarItem(icon: Icon(Icons.local_gas_station), label: 'Fuel'),
          BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Maintenance'),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => _onTap(context, index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement quick add logic
          showModalBottomSheet(
            context: context,
            builder: (context) => Wrap(
              children: [
                ListTile(leading: Icon(Icons.directions_car), title: Text('Add Vehicle'), onTap: () { context.pop(); context.push('/vehicles/add'); }),
                ListTile(leading: Icon(Icons.local_gas_station), title: Text('Add Fuel'), onTap: () { context.pop(); context.push('/fuel/add'); }),
                ListTile(leading: Icon(Icons.build), title: Text('Add Maintenance'), onTap: () { context.pop(); context.push('/maintenance/add'); }),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
