import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  final String id;
  final String userId;
  final String brand;
  final String model;
  final int year;
  final String licensePlate;
  final String fuelType;

  const Vehicle({
    required this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.year,
    required this.licensePlate,
    required this.fuelType,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      userId: json['userId'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      licensePlate: json['licensePlate'],
      fuelType: json['fuelType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'brand': brand,
      'model': model,
      'year': year,
      'licensePlate': licensePlate,
      'fuelType': fuelType,
    };
  }

  Vehicle copyWith({
    String? id,
    String? userId,
    String? brand,
    String? model,
    int? year,
    String? licensePlate,
    String? fuelType,
  }) {
    return Vehicle(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      fuelType: fuelType ?? this.fuelType,
    );
  }

  @override
  List<Object?> get props =>
      [id, userId, brand, model, year, licensePlate, fuelType];
}