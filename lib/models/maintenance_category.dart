import 'package:equatable/equatable.dart';

class MaintenanceCategory extends Equatable {
  final String id;
  final String name;
  final String icon;

  const MaintenanceCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory MaintenanceCategory.fromJson(Map<String, dynamic> json) {
    return MaintenanceCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  MaintenanceCategory copyWith({
    String? id,
    String? name,
    String? icon,
  }) {
    return MaintenanceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
    );
  }

  @override
  List<Object?> get props => [id, name, icon];
}