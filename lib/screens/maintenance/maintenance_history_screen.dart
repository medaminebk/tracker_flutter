import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/maintenance_provider.dart';
import '../../providers/maintenance_category_provider.dart';

class MaintenanceHistoryScreen extends ConsumerStatefulWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  ConsumerState<MaintenanceHistoryScreen> createState() => _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends ConsumerState<MaintenanceHistoryScreen> {
  DateTimeRange? _dateRange;
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    final maintenanceAsync = ref.watch(maintenanceProvider);
    final categoriesAsync = ref.watch(maintenanceCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance History')),
      body: Column(
        children: [
          // Filter Chips and Date Range
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.date_range),
                  onPressed: () async {
                    final range = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    setState(() {
                      _dateRange = range;
                    });
                  },
                ),
                Expanded(
                  child: categoriesAsync.when(
                    loading: () => const SizedBox.shrink(),
                    error: (err, stack) => Text('Error: $err'),
                    data: (categories) => Wrap(
                      spacing: 8.0,
                      children: categories.map((category) {
                        return FilterChip(
                          label: Text(category.name),
                          selected: _selectedCategoryId == category.id,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategoryId = selected ? category.id : null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: maintenanceAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
              data: (maintenanceList) {
                final filteredList = maintenanceList.where((m) {
                  bool matchesDate = _dateRange == null ||
                      (m.date.isAfter(_dateRange!.start) &&
                          m.date.isBefore(_dateRange!.end.add(const Duration(days: 1))));
                  bool matchesCategory =
                      _selectedCategoryId == null || m.categoryId == _selectedCategoryId;
                  return matchesDate && matchesCategory;
                }).toList();

                if (filteredList.isEmpty) {
                  return const Center(child: Text('No maintenance records found.'));
                }

                return ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final maintenance = filteredList[index];
                    return ListTile(
                      title: Text(maintenance.description),
                      subtitle: Text('${maintenance.date.toLocal().toString().split(' ')[0]} - ${maintenance.amount} MAD'),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
