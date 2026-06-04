import 'package:equatable/equatable.dart';

class FuelEntry extends Equatable {
  final String id;
  final String vehicleId;
  final String userId;
  final DateTime date;
  final double liters;
  final double amount;
  final int mileage;

  const FuelEntry({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.date,
    required this.liters,
    required this.amount,
    required this.mileage,
  });

  factory FuelEntry.fromJson(Map<String, dynamic> json) {
    return FuelEntry(
      id: json['id'],
      vehicleId: json['vehicleId'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      liters: json['liters'].toDouble(),
      amount: json['amount'].toDouble(),
      mileage: json['mileage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'userId': userId,
      'date': date.toIso8601String(),
      'liters': liters,
      'amount': amount,
      'mileage': mileage,
    };
  }

  FuelEntry copyWith({
    String? id,
    String? vehicleId,
    String? userId,
    DateTime? date,
    double? liters,
    double? amount,
    int? mileage,
  }) {
    return FuelEntry(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      liters: liters ?? this.liters,
      amount: amount ?? this.amount,
      mileage: mileage ?? this.mileage,
    );
  }

  @override
  List<Object?> get props =>
      [id, vehicleId, userId, date, liters, amount, mileage];
}