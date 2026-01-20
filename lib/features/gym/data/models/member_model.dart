// ignore_for_file: overridden_fields, annotate_overrides

import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/member.dart';

part 'member_model.g.dart';

@HiveType(typeId: 0)
class MemberModel extends Member {
  @HiveField(0)
  @override
  final String id;
  @HiveField(1)
  @override
  final String fullName;
  @HiveField(2)
  @override
  final DateTime startDate;
  @HiveField(3)
  @override
  final DateTime endDate;
  @HiveField(4)
  @override
  final MemberStatus status;
  @HiveField(5)
  @override
  final double paymentAmount;
  @HiveField(6)
  @override
  final String notes;

  const MemberModel({
    required this.id,
    required this.fullName,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.paymentAmount = 0.0,
    this.notes = '',
  }) : super(
         id: id,
         fullName: fullName,
         startDate: startDate,
         endDate: endDate,
         status: status,
         paymentAmount: paymentAmount,
         notes: notes,
       );

  factory MemberModel.fromEntity(Member member) {
    return MemberModel(
      id: member.id,
      fullName: member.fullName,
      startDate: member.startDate,
      endDate: member.endDate,
      status: member.status,
      paymentAmount: member.paymentAmount,
      notes: member.notes,
    );
  }
}
