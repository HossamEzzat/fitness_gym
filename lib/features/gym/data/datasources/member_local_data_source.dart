import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/member_model.dart';

abstract class MemberLocalDataSource {
  Future<List<MemberModel>> getMembers();
  Future<void> addMember(MemberModel member);
  Future<void> updateMember(MemberModel member);
  Future<void> deleteMember(String id);
}

class MemberLocalDataSourceImpl implements MemberLocalDataSource {
  final Box<MemberModel> memberBox;

  MemberLocalDataSourceImpl(this.memberBox);

  @override
  Future<List<MemberModel>> getMembers() async {
    return memberBox.values.toList();
  }

  @override
  Future<void> addMember(MemberModel member) async {
    await memberBox.put(member.id, member);
  }

  @override
  Future<void> updateMember(MemberModel member) async {
    await memberBox.put(member.id, member);
  }

  @override
  Future<void> deleteMember(String id) async {
    await memberBox.delete(id);
  }
}
