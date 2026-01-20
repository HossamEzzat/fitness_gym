import '../../domain/entities/member.dart';
import '../../domain/repositories/member_repository.dart';
import '../datasources/member_local_data_source.dart';
import '../models/member_model.dart';

class MemberRepositoryImpl implements MemberRepository {
  final MemberLocalDataSource localDataSource;

  MemberRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Member>> getMembers() async {
    final memberModels = await localDataSource.getMembers();
    return memberModels;
  }

  @override
  Future<void> addMember(Member member) async {
    final memberModel = MemberModel.fromEntity(member);
    await localDataSource.addMember(memberModel);
  }

  @override
  Future<void> updateMember(Member member) async {
    final memberModel = MemberModel.fromEntity(member);
    await localDataSource.updateMember(memberModel);
  }

  @override
  Future<void> deleteMember(String id) async {
    await localDataSource.deleteMember(id);
  }
}
