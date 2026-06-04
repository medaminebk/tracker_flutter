import 'package:equatable/equatable.dart';

class Maintenance extends Equatable {
  final String id;
  final String vehicleId;
  final String userId;
  final DateTime date;
  final String description;
  final double amount;
  final String categoryId;

  const Maintenance({
    required this.id,
    required this.vehicleId,
    required this.userId,
    required this.date,
    required this.description,
    required this.amount,
    required this.categoryId,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json) {
    return Maintenance(
      id: json['id'],
      vehicleId: json['vehicleId'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      amount: json['amount'].toDouble(),
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'userId': userId,
      'date': date.toIso8601String(),
      'description': description,
      'amount': amount,
      'categoryId': categoryId,
    };
  }

  Maintenance copyWith({
    String? id,
    String? vehicleId,
    String? userId,
    DateTime? date,
    String? description,
    double? amount,
    String? categoryId,
  }) {
    return Maintenance(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
    );
  }

  @override
  List<Object?> get props =>
      [id, vehicleId, userId, date, description, amount, categoryId];
}