import 'package:equatable/equatable.dart';
import '../../domain/entities/member.dart';

abstract class MemberEvent extends Equatable {
  const MemberEvent();

  @override
  List<Object> get props => [];
}

class LoadMembers extends MemberEvent {}

class AddMemberEvent extends MemberEvent {
  final Member member;

  const AddMemberEvent(this.member);

  @override
  List<Object> get props => [member];
}

class UpdateMemberEvent extends MemberEvent {
  final Member member;

  const UpdateMemberEvent(this.member);

  @override
  List<Object> get props => [member];
}

class DeleteMemberEvent extends MemberEvent {
  final String id;

  const DeleteMemberEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FilterMembers extends MemberEvent {
  final String query;
  final MemberStatus? status;

  const FilterMembers({this.query = '', this.status});

  @override
  List<Object> get props => [query, status ?? ''];
}
