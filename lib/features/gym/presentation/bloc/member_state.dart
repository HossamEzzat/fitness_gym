import 'package:equatable/equatable.dart';
import '../../domain/entities/member.dart';

enum MemberStatusFilter { all, active, expired, expiringSoon }

abstract class MemberState extends Equatable {
  const MemberState();

  @override
  List<Object> get props => [];
}

class MemberInitial extends MemberState {}

class MemberLoading extends MemberState {}

class MemberLoaded extends MemberState {
  final List<Member> members;
  final List<Member> filteredMembers;

  const MemberLoaded(this.members, {this.filteredMembers = const []});

  @override
  List<Object> get props => [members, filteredMembers];
}

class MemberError extends MemberState {
  final String message;

  const MemberError(this.message);

  @override
  List<Object> get props => [message];
}
