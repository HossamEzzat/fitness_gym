import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/member_repository.dart';
import 'member_event.dart';
import 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberRepository repository;

  MemberBloc({required this.repository}) : super(MemberInitial()) {
    on<LoadMembers>(_onLoadMembers);
    on<AddMemberEvent>(_onAddMember);
    on<UpdateMemberEvent>(_onUpdateMember);
    on<DeleteMemberEvent>(_onDeleteMember);
    on<FilterMembers>(_onFilterMembers);
  }

  Future<void> _onLoadMembers(
    LoadMembers event,
    Emitter<MemberState> emit,
  ) async {
    emit(MemberLoading());
    try {
      final members = await repository.getMembers();
      emit(MemberLoaded(members, filteredMembers: members));
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }

  Future<void> _onAddMember(
    AddMemberEvent event,
    Emitter<MemberState> emit,
  ) async {
    try {
      await repository.addMember(event.member);
      add(LoadMembers());
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }

  Future<void> _onUpdateMember(
    UpdateMemberEvent event,
    Emitter<MemberState> emit,
  ) async {
    try {
      await repository.updateMember(event.member);
      add(LoadMembers());
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }

  Future<void> _onDeleteMember(
    DeleteMemberEvent event,
    Emitter<MemberState> emit,
  ) async {
    try {
      await repository.deleteMember(event.id);
      add(LoadMembers());
    } catch (e) {
      emit(MemberError(e.toString()));
    }
  }

  void _onFilterMembers(FilterMembers event, Emitter<MemberState> emit) {
    if (state is MemberLoaded) {
      final currentState = state as MemberLoaded;
      final filtered = currentState.members.where((member) {
        final matchesQuery = member.fullName.toLowerCase().contains(
          event.query.toLowerCase(),
        );
        final matchesStatus =
            event.status == null || member.status == event.status;
        return matchesQuery && matchesStatus;
      }).toList();
      emit(MemberLoaded(currentState.members, filteredMembers: filtered));
    }
  }
}
