import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'member.g.dart';

@HiveType(typeId: 1)
enum MemberStatus {
  @HiveField(0)
  active,
  @HiveField(1)
  expiringSoon,
  @HiveField(2)
  expired;

  String get label {
    switch (this) {
      case MemberStatus.active:
        return 'نشط';
      case MemberStatus.expiringSoon:
        return 'ينتهي قريباً';
      case MemberStatus.expired:
        return 'منتهي';
    }
  }

  Color get color {
    switch (this) {
      case MemberStatus.active:
        return const Color(0xFF4CAF50);
      case MemberStatus.expiringSoon:
        return const Color(0xFFFF9800);
      case MemberStatus.expired:
        return const Color(0xFFF44336);
    }
  }
}

class Member extends Equatable {
  final String id;
  final String fullName;
  final DateTime startDate;
  final DateTime endDate;
  final MemberStatus status;

  final double paymentAmount;
  final String notes;

  const Member({
    required this.id,
    required this.fullName,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.paymentAmount = 0.0,
    this.notes = '',
  });

  bool get isExpired => DateTime.now().isAfter(endDate);

  bool get isExpiringSoon =>
      !isExpired &&
      endDate.isBefore(DateTime.now().add(const Duration(days: 7)));

  bool get isNew => DateTime.now().difference(startDate).inDays < 3;

  Member copyWith({
    String? fullName,
    DateTime? startDate,
    DateTime? endDate,
    MemberStatus? status,
    double? paymentAmount,
    String? notes,
  }) {
    return Member(
      id: id,
      fullName: fullName ?? this.fullName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      paymentAmount: paymentAmount ?? this.paymentAmount,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    startDate,
    endDate,
    status,
    paymentAmount,
    notes,
  ];
}
